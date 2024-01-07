module Stories
  module Chapters
    class CoversController < ApplicationController
      before_action :set_story
      before_action :set_chapter

      # @route PATCH /stories/:story_id/chapters/:chapter_id/covers (story_chapter_covers)
      # @route PUT /stories/:story_id/chapters/:chapter_id/covers (story_chapter_covers)
      def update
        authorize! @chapter, with: ::Chapters::CoverPolicy

        ReplicateServices::Picture.call(@chapter, @chapter.summary)

        respond_to do |format|
          notice = 'La couverture du chapitre est en cours de création'

          format.html { redirect_to root_path, notice: notice }
          format.turbo_stream { flash.now[:notice] = notice }
        end
      end

      private

      def set_story
        @story = company.stories.find(params[:story_id])
      end

      def set_chapter
        @chapter = @story.chapters.find(params[:chapter_id])
      end
    end
  end
end
