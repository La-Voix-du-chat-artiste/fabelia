class HomesController < ApplicationController
  # @route GET / (root)
  def show
    @stories = if display_ended?
      Story.ended
    else
      Story.currents
    end

    @active_stories = [
      Story.complete.currents.enabled.french.first,
      Story.complete.currents.enabled.english.first
    ].compact

    @pagy, @stories = pagy(@stories.with_attached_cover.order(updated_at: :desc), items: 6)
  end

  private

  def display_ended?
    params[:display_ended].to_bool
  end
end
