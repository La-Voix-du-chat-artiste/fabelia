class StoriesController < ApplicationController
  before_action :set_story, only: %i[update destroy]

  # @route POST /stories (stories)
  def create
    case mode
    when :dropper
      GenerateDropperStoryJob.perform_later(language, thematic)

      flash[:notice] = 'Le premier chapitre de cette nouvelle aventure est en cours de création'
    when :complete
      GenerateFullStoryJob.perform_later(language, thematic)

      flash[:notice] = "L'aventure pré-générée est en cours de création, veuillez patienter le temps que ChatGPT et Replicate finissent de tout générer."
    else
      redirect_to root_path, alert: 'Unsupported story mode'
      return
    end

    redirect_to root_path
  rescue OpenaiChatgpt::Error, StandardError => e
    redirect_to root_path, alert: "#{e.message} => #{e.backtrace}"
  end

  # @route PATCH /stories/:id (story)
  # @route PUT /stories/:id (story)
  def update
    @story.toggle!(:enabled)

    redirect_to root_path, notice: "L'aventure a bien été mise à jour"
  end

  # @route DELETE /stories/:id (story)
  def destroy
    @story.destroy

    redirect_to root_path, notice: "L'aventure a bien été supprimée"
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:language, :mode, :thematic_id)
  end

  def mode
    story_params[:mode].presence.to_sym || :complete
  end

  def language
    story_params[:language].presence.to_sym || :french
  end

  def thematic
    if story_params[:thematic_id].blank?
      Thematic.enabled.sample
    else
      Thematic.enabled.find(story_params[:thematic_id])
    end
  end
end
