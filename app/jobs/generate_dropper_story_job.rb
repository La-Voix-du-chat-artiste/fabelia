class GenerateDropperStoryJob < ApplicationJob
  def perform(prompt, language)
    Retry.on(
      Net::ReadTimeout,
      JSON::ParserError,
      ChapterErrors::MissingPollOptions
    ) do
      @json = ChatgptDropperService.call(prompt, language)
    end

    ApplicationRecord.transaction do
      @story = Story.create!(
        title: prompt,
        adventure_ended_at: nil,
        mode: :dropper,
        language: language
      )

      story_cover_prompt = "#{@story.title}, book, adventure, cover, title, detailled, 4k"
      ReplicateServices::Picture.call(@story, story_cover_prompt, publish: false)

      @chapter = @story.chapters.create!(
        title: @json['title'],
        content: @json['content'],
        summary: @json['summary'],
        prompt: prompt,
        chat_raw_response_body: @json
      )

      sleep 3

      ReplicateServices::Picture.call(@chapter, @chapter.summary, publish: true)
    end
  end
end
