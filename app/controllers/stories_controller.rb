class StoriesController < ApplicationController
  before_action :set_story, only: :update

  # @route POST /stories (stories)
  def create
    if !force_new_adventure? && Story.current?
      # Find last non published chapter of current story
      @story = Story.currents.last
      @chapter = @story.chapters.where(published_at: nil).first
    else
      # Generate a brand new story
      json = ChatgptService.call(prompt)

      ApplicationRecord.transaction do
        @story = Story.create!(
          title: json['title'],
          adventure_ended_at: nil,
          raw_response_body: json
        )

        json['chapters'].each do |chapter|
          @story.chapters.create!(
            title: chapter['title'],
            content: chapter['content'],
            summary: chapter['summary']
          )
        end
      end

      @chapter = @story.chapters.first
    end

    ReplicateServices::Picture.call(@chapter, @chapter.summary)

    redirect_to root_path, notice: "L'aventure va être publiée sur Nostr après réponse de l'API Replicate"
  rescue OpenaiChatgpt::Error, StandardError => e
    redirect_to root_path, alert: e.message
  end

  # @route PATCH /stories/:id (story)
  # @route PUT /stories/:id (story)
  def update
    @chapter = @story.chapters.where(published_at: nil).first

    ReplicateServices::Picture.call(@chapter, @chapter.summary)

    redirect_to root_path, notice: "La suite de l'aventure va être publiée sur Nostr après réponse de l'API Replicate"
  rescue OpenaiChatgpt::Error, StandardError => e
    redirect_to root_path, alert: e.message
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end

  def force_new_adventure?
    params[:force_new_adventure].present? && params[:force_new_adventure] == 'true'
  end

  def prompt
    "Début de l'aventure #{thematics}"
  end

  def thematics
    ['médiévale', 'spatiale', 'maritime', 'en ville', 'dans la jungle', 'en bord de mer', "sous l'eau"].sample
  end
end
