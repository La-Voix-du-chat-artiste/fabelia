class GenerateDropperStoryJob < ApplicationJob
  def perform(language, thematic = nil)
    thematic ||= Thematic.enabled.sample

    lang = language.to_s.first(2)
    description = thematic.send("description_#{lang}")
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
      ReplicateServices::Picture.call(@story, story_cover_prompt)

      @chapter = @story.chapters.create!(
        title: @json['title'],
        content: @json['content'],
        prompt: prompt,
        chat_raw_response_body: @json
      )

      # Call ChatGPT to make an accurate chapter summary
      chapter_cover_prompt = ChatgptSummaryService.call(@chapter.content)
      @chapter.update(summary: chapter_cover_prompt)
      ReplicateServices::Picture.call(@chapter, @chapter.summary, publish: true)
    end
  end
end
