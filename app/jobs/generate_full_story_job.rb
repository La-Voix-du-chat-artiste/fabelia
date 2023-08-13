class GenerateFullStoryJob < ApplicationJob
  # TODO: Validate that a nostr_user is enabled for a language or raise
  # TODO: Validate that thematic is properly enabled or raise
  # @param draft_story [Story] draft story to generate
  # @param publish [Boolean] Should the {Chapter} be published ?
  def perform(draft_story, publish: false)
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
      ChapterErrors::FullStoryMissingChapters
    ) do
      @json = ChatgptCompleteService.call(prompt, nostr_user.language)

      raise ChapterErrors::FullStoryMissingChapters if @json['chapters'].count < 3
    end

    Story.broadcast_flash(:notice, <<~CONTENT)
      L'aventure <strong>#{@json['title']}</strong> vient d'être générée avec <strong>#{@json['chapters'].count} chapitres</strong>.
    CONTENT

    ApplicationRecord.transaction do
      story_accurate_cover_prompt = ChatgptSummaryService.call("#{@json['title']}, #{draft_story.thematic_description}")

      draft_story.update!(
        title: @json['title'],
        raw_response_body: @json,
        summary: story_accurate_cover_prompt
      )

      @json['chapters'].each_with_index do |row, index|
        chapter_accurate_cover_prompt = ChatgptSummaryService.call(row['content'])

        draft_story.chapters.create!(
          title: row['title'],
          content: row['content'],
          summary: chapter_accurate_cover_prompt,
          chat_raw_response_body: row,
          publish: publish == :all || (publish && index.zero?)
        )
      end

      draft_story.completed!
    end
  end
end
