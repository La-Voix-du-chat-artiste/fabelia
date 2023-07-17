class HomesController < ApplicationController
  # @route GET / (root)
  def show
    @stories = Story.includes(:chapters).order(id: :desc)
  end
end
