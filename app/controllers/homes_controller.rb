class HomesController < ApplicationController
  # @route GET / (root)
  def show
    @stories = if display_ended?
      Story.ended
    else
      Story.currents
    end

    @publishable_stories = Story.publishable

    @active_stories = {
      french: @publishable_stories.french.first,
      english: @publishable_stories.english.first
    }

    @pagy, @stories = pagy(@stories.with_attached_cover.order(updated_at: :desc), items: 6)
  end

  private

  def display_ended?
    params[:display_ended].to_bool
  end
end
