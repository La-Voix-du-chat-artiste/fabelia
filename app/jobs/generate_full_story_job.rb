class GenerateFullStoryJob < ApplicationJob
  def perform(prompt)
    Retry.on(Net::ReadTimeout, JSON::ParserError) do
      @json = ChatgptCompleteService.call(prompt)
    end

    ApplicationRecord.transaction do
      @story = Story.create!(
        title: @json['title'],
        adventure_ended_at: nil,
        raw_response_body: @json,
        mode: :complete
      )

      story_cover_prompt = "#{@story.title}, book, adventure, cover, title"
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
