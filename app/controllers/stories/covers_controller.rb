module Stories
  class CoversController < ApplicationController
    before_action :set_story

    # @route PATCH /stories/:story_id/covers (story_covers)
    # @route PUT /stories/:story_id/covers (story_covers)
    def update
      authorize! @story, with: Stories::CoverPolicy

      ReplicateServices::Picture.call(@story, @story.summary)

      redirect_to root_path, notice: "La couverture de l'histoire est en cours de création"
    end

    private

    def set_story
      @story = Story.enabled.find(params[:story_id])
    end
  end
end
