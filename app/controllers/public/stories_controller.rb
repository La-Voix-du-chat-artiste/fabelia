module Public
  class StoriesController < ApplicationController
    skip_before_action :require_login

    before_action :set_story

    # @route GET /p/s/:id (public_story)
    def show
      authorize! @story

      respond_to do |format|
        format.pdf { render pdf: @story.title }
      end
    end

    private

    def set_story
      @story = Story.find(params[:id])
    end

    def unauthorized_access(e)
      policy_name = e.policy.to_s.underscore
      message = t "#{policy_name}.#{e.rule}", scope: 'action_policy', default: :default

      redirect_to new_sessions_path, alert: message
    end
  end
end
