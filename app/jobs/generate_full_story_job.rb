class GenerateFullStoryJob < ApplicationJob
  def perform(language, publish: false)
    thematic = Thematic.enabled.sample
    lang = language.to_s.first(2)

    description = thematic.send("description_#{lang}")
    prompt = I18n.t('begin_adventure', description: description)

    Retry.on(
      Net::ReadTimeout,
      JSON::ParserError,
      ChapterErrors::FullStoryMissingChapters
    ) do
      @json = ChatgptCompleteService.call(prompt, language)

      raise ChapterErrors::FullStoryMissingChapters if @json['chapters'].count < 3
    end

    ApplicationRecord.transaction do
      nostr_user = NostrUser.find_sole_by(language: language)

      @story = Story.create!(
        title: @json['title'],
        adventure_ended_at: nil,
        raw_response_body: @json,
        mode: :complete,
        language: language,
        thematic: thematic,
        nostr_user: nostr_user
      )

      story_cover_prompt = "detailed book illustration, #{@story.title}, #{description}"
      ReplicateServices::Picture.call(@story, story_cover_prompt)

      @json['chapters'].each_with_index do |row, index|
        @chapter = @story.chapters.create!(
          title: row['title'],
          content: row['content'],
          summary: row['summary'],
          chat_raw_response_body: row
        )

        ReplicateServices::Picture.call(@chapter, @chapter.summary, publish: (publish && index.zero?))
      end
    end
  end
end
