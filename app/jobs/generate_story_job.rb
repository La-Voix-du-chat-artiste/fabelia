class GenerateStoryJob < ApplicationJob
  private

  def process!(draft_story, retryable_ai_errors, publish: false)
    nostr_user = draft_story.nostr_user

    flash_message = <<~MESSAGE
      - Mode: <strong>#{draft_story.human_mode}</strong>
      - Thèmatique: <strong>#{draft_story.thematic_name}</strong>
      - Compte Nostr: <strong>#{nostr_user.profile.identity}</strong>
      - Langue: <strong>#{nostr_user.human_language}</strong>
    MESSAGE

    Story.broadcast_flash(:notice, flash_message)

    prompt = I18n.t('begin_adventure', description: draft_story.thematic_description)

    Retry.on(retryable_ai_errors) do
      if draft_story.complete?
        @json = ChatgptCompleteService.call(prompt, nostr_user.language)

        raise ChapterErrors::FullStoryMissingChapters if @json['chapters'].count < 3
      else
        @json = ChatgptDropperService.call(prompt, nostr_user.language)
      end
    end

     if draft_story.complete?
      story_title = @json['title']

      flash_message = <<~MESSAGE
        L'aventure <strong>#{story_title}</strong> vient d'être générée avec <strong>#{@json['chapters'].count} chapitres</strong>.
      MESSAGE
    else
      story_title = @json['story_title']

      flash_message = <<~MESSAGE
        L'aventure <strong>#{story_title}</strong> vient d'être générée.
      MESSAGE
    end

    Story.broadcast_flash(:notice, flash_message)

    ApplicationRecord.transaction do
      story_accurate_cover_prompt = ChatgptSummaryService.call("#{story_title}, #{draft_story.thematic_description}")

      draft_story.update!(
        title: story_title,
        raw_response_body: @json,
        summary: story_accurate_cover_prompt
      )

      if draft_story.dropper?
        @json['chapters'] = [@json.except(:story_title)]
      end

      @json['chapters'].each_with_index do |row, index|
        chapter_accurate_cover_prompt = ChatgptSummaryService.call(row['content'])

        publish_value = if draft_story.complete?
          publish == :all || (publish && index.zero?)
        else
          publish
        end

        draft_story.chapters.create!(
          title: row['title'],
          content: row['content'],
          summary: chapter_accurate_cover_prompt,
          chat_raw_response_body: row,
          publish: publish_value
        )
      end

      draft_story.completed!
    end
  end
end
