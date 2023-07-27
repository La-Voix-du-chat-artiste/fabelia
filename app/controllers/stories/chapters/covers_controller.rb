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

        redirect_to root_path, notice: "La couverture de l'histoire est en cours de création"
      end

      private

      def set_story
        @story = Story.enabled.find(params[:story_id])
      end

      def set_chapter
        @chapter = @story.chapters.find(params[:chapter_id])
      end
    end
  end
end
