class StoriesController < ApplicationController
  before_action :set_story, only: %i[update destroy]

  # @route POST /stories (stories)
  def create
    authorize! Story

    @story = Story.new(story_params) do |story|
      story.status = :draft
    end

    if @story.save
      case mode
      when :dropper
        GenerateDropperStoryJob.perform_later(@story)

        notice = 'Le premier chapitre de cette nouvelle aventure est en cours de création'
      when :complete
        GenerateFullStoryJob.perform_later(@story)

        notice = "L'aventure pré-générée est en cours de création, veuillez patienter le temps que ChatGPT et Replicate finissent de tout générer."
      else
        redirect_to root_path, alert: 'Unsupported story mode'
        return
      end

      respond_to do |format|
        format.html { redirect_to root_path, notice: notice }
        format.turbo_stream { flash.now[:notice] = notice }
      end
    else
      redirect_to root_path, alert: @story.errors.full_messages.join(', ')
    end
  rescue OpenaiChatgpt::Error, StandardError => e
    redirect_to root_path, alert: "#{e.message} // #{e.backtrace}"
  end

  # @route PATCH /stories/:id (story)
  # @route PUT /stories/:id (story)
  def update
    authorize! @story

    @story.toggle!(:enabled)

    redirect_to root_path, notice: "L'aventure a bien été mise à jour"
  end

  # @route DELETE /stories/:id (story)
  def destroy
    authorize! @story

    NostrJobs::StoryDeletionJob.perform_later(@story)

    respond_to do |format|
      notice = "L'aventure est en cours de suppression"

      format.html { redirect_to root_path, notice: notice }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  private

  def set_story
    @story = Story.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:nostr_user_id, :mode, :thematic_id)
  end

  def mode
    story_params[:mode].to_sym
  end
end
