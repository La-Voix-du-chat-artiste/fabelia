class HomesController < ApplicationController
  # @route GET / (root)
  def show
    @chapter = Chapter.published.last
  end
end
