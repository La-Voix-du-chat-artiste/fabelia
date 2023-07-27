class GenerateDropperStoryJob < ApplicationJob
  def perform(language)
    thematic = Thematic.enabled.sample

    description = thematic.send("description_#{language.to_s.first(2)}")
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

      ReplicateServices::Picture.call(@story, @story.summary)

      @chapter = @story.chapters.create!(
        title: @json['title'],
        content: @json['content'],
        summary: @json['summary'],
        prompt: prompt,
        chat_raw_response_body: @json
      )

      ReplicateServices::Picture.call(@chapter, @chapter.summary, publish: true)
    end
  end
end
