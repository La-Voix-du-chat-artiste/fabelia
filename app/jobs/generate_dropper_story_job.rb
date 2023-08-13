class GenerateDropperStoryJob < ApplicationJob
  # TODO: Validate that a nostr_user is enabled for a language or raise
  # TODO: Validate that thematic is properly enabled or raise
  # @param draft_story [Story] draft story to generate
  def perform(draft_story)
    nostr_user = draft_story.nostr_user

    flash_message = <<~CONTENT
      - Mode: <strong>#{draft_story.human_mode}</strong>
      - Thèmatique: <strong>#{draft_story.thematic_name}</strong>
      - Compte Nostr: <strong>#{nostr_user.profile.identity}</strong>
      - Langue: <strong>#{nostr_user.human_language}</strong>
    CONTENT

    Story.broadcast_flash(:notice, flash_message)

    prompt = I18n.t('begin_adventure', description: draft_story.thematic_description)

    Retry.on(
      Net::ReadTimeout,
      JSON::ParserError,
      ChapterErrors::EmptyPollOptions,
      ChapterErrors::MissingPollOptions
    ) do
      @json = ChatgptDropperService.call(prompt, nostr_user.language)
    end

    Story.broadcast_flash(:notice, <<~CONTENT)
      L'aventure <strong>#{@json['story_title']}</strong> vient d'être générée.
    CONTENT

    ApplicationRecord.transaction do
      story_accurate_cover_prompt = ChatgptSummaryService.call("#{@json['story_title']}, #{draft_story.thematic_description}")

      draft_story.update!(
        title: @json['story_title'],
        raw_response_body: @json,
        summary: story_accurate_cover_prompt
      )

      chapter_accurate_cover_prompt = ChatgptSummaryService.call(@json['content'])

      draft_story.chapters.create!(
        title: @json['title'],
        content: @json['content'],
        prompt: prompt,
        summary: chapter_accurate_cover_prompt,
        chat_raw_response_body: @json,
        publish: true
      )

      draft_story.completed!
    end
  end
end
