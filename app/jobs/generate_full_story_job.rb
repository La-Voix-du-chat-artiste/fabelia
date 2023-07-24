class GenerateFullStoryJob < ApplicationJob
  def perform(prompt, language)
    Retry.on(Net::ReadTimeout, JSON::ParserError) do
      @json = ChatgptCompleteService.call(prompt, language)
    end

    ApplicationRecord.transaction do
      @story = Story.create!(
        title: @json['title'],
        adventure_ended_at: nil,
        raw_response_body: @json,
        mode: :complete,
        language: language
      )

      story_cover_prompt = "#{@story.title}, book, adventure, cover, title, detailled, 4k"
      ReplicateServices::Picture.call(@story, story_cover_prompt)

      @json['chapters'].each_with_index do |row, _index|
        @chapter = @story.chapters.create!(
          title: row['title'],
          content: row['content'],
          summary: row['summary'],
          chat_raw_response_body: row
        )

        ReplicateServices::Picture.call(@chapter, @chapter.summary)
      end
    end
  end
end
