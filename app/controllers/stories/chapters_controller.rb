module Stories
  class ChaptersController < ApplicationController
    before_action :set_story
    before_action :set_chapter, only: :publish

    # @route POST /stories/:story_id/chapters (story_chapters)
    def create
      prompt = set_prompt

      Retry.on(
        Net::ReadTimeout,
        JSON::ParserError,
        ChapterErrors::EmptyPollOptions,
        ChapterErrors::MissingPollOptions
      ) do
        @json = ChatgptDropperService.call(prompt, @story.language, @story)
      end

      ApplicationRecord.transaction do
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

      redirect_to root_path, notice: "Un nouveau chapitre vient d'être créé"
    end

    # @route POST /stories/:story_id/chapters/publish_next (publish_next_story_chapters)
    def publish_next
      raise StoryErrors::MissingCover unless @story.cover.attached?

      @chapter = @story.chapters.not_published.first

      NostrPublisherService.call(@chapter)

      redirect_to root_path, notice: 'Le chapitre va être publié sur Nostr'
    end

    # @route POST /stories/:story_id/chapters/publish_all (publish_all_story_chapters)
    def publish_all
      raise StoryErrors::MissingCover unless @story.cover.attached?

      @story.chapters.not_published.order(id: :asc).each do |chapter|
        NostrPublisherService.call(chapter)
        sleep 3
      end

      redirect_to root_path, notice: 'Tous les chapitres vont être publiés sur Nostr'
    end

    # @route POST /stories/:story_id/chapters/:id/publish (publish_story_chapter)
    def publish
      NostrPublisherService.call(@chapter)

      redirect_to root_path, notice: 'Le chapitre va être publié sur Nostr'
    end

    private

    def set_story
      @story = Story.enabled.find(params[:story_id])
    end

    def set_chapter
      @chapter = @story.chapters.find(params[:id])
    end

    def set_prompt
      return "Termine l'aventure de manière cohérente avec un tout dernier chapitre" if force_end_of_story?

      last_published_chapter = @story.chapters.published.last
      last_published_chapter.most_voted_option
    end

    def force_end_of_story?
      params[:force_end].to_bool
    end
  end
end
