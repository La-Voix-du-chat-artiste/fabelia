class StoriesController < ApplicationController
  # @route POST /stories (stories)
  def create
    case mode
    when :dropper
      GenerateDropperStoryJob.perform_later(prompt, language)

      flash[:notice] = 'Le premier chapitre de cette nouvelle aventure est en cours de création'
    when :complete
      GenerateFullStoryJob.perform_later(prompt, language)

      flash[:notice] = "L'aventure complète est en cours de création, veuillez patienter le temps que ChatGPT et Replicate finissent de tout générer."
    else
      redirect_to root_path, alert: 'Unsupported story mode'
      return
    end

    redirect_to root_path
  rescue OpenaiChatgpt::Error, StandardError => e
    redirect_to root_path, alert: "#{e.message} => #{e.backtrace}"
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end

  def prompt
    if language == :french
      "Début de l'aventure #{Story::THEMATICS.sample}"
    else
      "Beginning of adventure #{Story::THEMATICS.sample}"
    end
  end

  def mode
    params[:mode].presence&.to_sym || :complete
  end

  def language
    params[:language].to_sym || :french
  end
end
