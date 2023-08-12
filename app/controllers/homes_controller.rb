class HomesController < ApplicationController
  helper_method :display_ended?

  # @route GET / (root)
  def show
    @stories = if display_ended?
      Story.ended
    else
      Story.currents
    end

    @publishable_stories = Story.publishable

    @active_stories = {}
    NostrUser.pluck(:language).each do |language|
      @active_stories[language] = Story.publishable(language: language).first
    end

    @pagy, @stories = pagy(@stories.with_attached_cover.order(updated_at: :desc), items: 6)
  end

  private

  def display_ended?
    params[:display_ended].to_bool
  end
end
