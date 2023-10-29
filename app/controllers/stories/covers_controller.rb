module Stories
  class CoversController < ApplicationController
    before_action :set_story

    # @route PATCH /stories/:story_id/covers (story_covers)
    # @route PUT /stories/:story_id/covers (story_covers)
    def update
      authorize! @story, with: Stories::CoverPolicy

      ReplicateServices::Picture.call(@story, @story.summary)

      respond_to do |format|
        notice = "La couverture de l'histoire est en cours de création"

        format.html { redirect_to root_path, notice: notice }
        format.turbo_stream { flash.now[:notice] = notice }
      end
    end

    private

    def set_story
      @story = company.stories.find(params[:story_id])
    end
  end
end
