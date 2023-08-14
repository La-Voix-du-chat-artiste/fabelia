module Stories
  class ChaptersController < ApplicationController
    before_action :set_story
    before_action :set_chapter, only: :publish

    # @route POST /stories/:story_id/chapters (story_chapters)
    def create
      authorize! Chapter, context: { story: @story }

      GenerateDropperChapterJob.perform_later(@story, force_ending: force_end_of_story?)

      respond_to do |format|
        notice = 'Un nouveau chapitre est en cours de création'

        format.html { redirect_to root_path, notice: notice }
        format.turbo_stream { flash.now[:notice] = notice }
      end
    end

    # @route POST /stories/:story_id/chapters/publish_next (publish_next_story_chapters)
    def publish_next
      @chapter = @story.chapters.not_published.first

      authorize! @chapter, context: { story: @story }

      NostrJobs::SinglePublisherJob.perform_later(@chapter)

      respond_to do |format|
        notice = 'Le chapitre est en cours de publication sur Nostr'

        format.html { redirect_to root_path, notice: notice }
        format.turbo_stream { flash.now[:notice] = notice }
      end
    end

    # @route POST /stories/:story_id/chapters/publish_all (publish_all_story_chapters)
    def publish_all
      authorize! Chapter, context: { story: @story }

      NostrJobs::AllPublisherJob.perform_later(@story)

      respond_to do |format|
        notice = 'Tous les chapitres sont en cours de publication sur Nostr'

        format.html { redirect_to root_path, notice: notice }
        format.turbo_stream { flash.now[:notice] = notice }
      end
    end

    # @route POST /stories/:story_id/chapters/:id/publish (publish_story_chapter)
    def publish
      authorize! @chapter, context: { story: @story }

      NostrJobs::SinglePublisherJob.perform_later(@chapter)

      respond_to do |format|
        notice = 'Le chapitre est en cours de publication sur Nostr'

        format.html { redirect_to root_path, notice: notice }
        format.turbo_stream { flash.now[:notice] = notice }
      end
    end

    private

    def set_story
      @story = Story.find(params[:story_id])
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
