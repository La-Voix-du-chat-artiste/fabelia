class GenerateFullStoryJob < ApplicationJob
  # TODO: Validate that a nostr_user is enabled for a language or raise
  # TODO: Validate that thematic is properly enabled or raise
  # @param language [String] Language code based on ISO 639-1 standard
  # @param thematic [Thematic|NilClass] Story's thematic or nil
  # @param publish [Boolean] Should the {Chapter} be published ?
  def perform(language, thematic = nil, publish: false)
    thematic ||= Thematic.enabled.sample

    description = thematic.send("description_#{language}")
    prompt = I18n.t('begin_adventure', description: description)

    Retry.on(
      Net::ReadTimeout,
      JSON::ParserError,
      ChapterErrors::FullStoryMissingChapters,
      times: 5
    ) do
      @json = ChatgptCompleteService.call(prompt, language)

      raise ChapterErrors::FullStoryMissingChapters if @json['chapters'].count < 3
    end

    ApplicationRecord.transaction do
      @story = Story.create!(
        title: @json['title'],
        adventure_ended_at: nil,
        raw_response_body: @json,
        mode: :complete,
        language: language,
        thematic: thematic
      )

      # Call ChatGPT to make an accurate story summary
      story_cover_prompt = ChatgptSummaryService.call("#{@story.title}, #{description}")
      @story.update(summary: story_cover_prompt)

      @json['chapters'].each_with_index do |row, index|
        @chapter = @story.chapters.create!(
          title: row['title'],
          content: row['content'],
          summary: row['summary'],
          chat_raw_response_body: row,
          publish: publish == :all || (publish && index.zero?)
        )

        # Call ChatGPT to make an accurate chapter summary
        chapter_cover_prompt = ChatgptSummaryService.call(@chapter.content)
        @chapter.update(summary: chapter_cover_prompt)
      end
    end
  end
end
