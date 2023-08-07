class GenerateDropperStoryJob < ApplicationJob
  # TODO: Validate that a nostr_user is enabled for a language or raise
  # TODO: Validate that thematic is properly enabled or raise
  # @param language [String] Language code based on ISO 639-1 standard
  # @param thematic [Thematic|NilClass] Story's thematic or nil
  def perform(language, thematic = nil)
    thematic ||= Thematic.enabled.sample

    description = thematic.send("description_#{language}")
    prompt = I18n.t('begin_adventure', description: description)

    Retry.on(
      Net::ReadTimeout,
      JSON::ParserError,
      ChapterErrors::EmptyPollOptions,
      ChapterErrors::MissingPollOptions
    ) do
      @json = ChatgptDropperService.call(prompt, language)
    end

    ApplicationRecord.transaction do
      @story = Story.create!(
        title: @json['story_title'],
        adventure_ended_at: nil,
        mode: :dropper,
        language: language,
        thematic: thematic
      )

      # Call ChatGPT to make an accurate story summary
      story_cover_prompt = ChatgptSummaryService.call("#{@story.title}, #{description}")
      @story.update(summary: story_cover_prompt)

      @chapter = @story.chapters.create!(
        title: @json['title'],
        content: @json['content'],
        prompt: prompt,
        chat_raw_response_body: @json
      )

      # Call ChatGPT to make an accurate chapter summary
      chapter_cover_prompt = ChatgptSummaryService.call(@chapter.content)
      @chapter.update(summary: chapter_cover_prompt, publish: true)
    end
  end
end
