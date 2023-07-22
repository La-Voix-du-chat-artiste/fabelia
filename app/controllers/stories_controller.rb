class StoriesController < ApplicationController
  # @route POST /stories (stories)
  def create
    case mode
    when :dropper
      generate_dropper_story

      flash[:notice] = 'Le premier chapitre de cette nouvelle aventure est en cours de création'
    when :complete
      GenerateFullStoryJob.perform_later(prompt)

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
    "Début de l'aventure #{Story::THEMATICS.sample}"
  end

  def mode
    params[:mode].presence&.to_sym || :complete
  end

  def generate_dropper_story
    Retry.on(Net::ReadTimeout, JSON::ParserError) do
      @json = ChatgptDropperService.call(prompt)
    end

    ApplicationRecord.transaction do
      @story = Story.create!(
        title: prompt,
        adventure_ended_at: nil,
        mode: :dropper
      )

      @chapter = @story.chapters.create!(
        title: @json['title'],
        content: @json['content'],
        summary: @json['summary'],
        prompt: prompt,
        chat_raw_response_body: @json
      )

      ReplicateServices::Picture.call(@chapter, @chapter.summary, publish: true)
    end
  end
end
