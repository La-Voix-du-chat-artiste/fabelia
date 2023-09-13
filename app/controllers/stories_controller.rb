class StoriesController < ApplicationController
  before_action :set_story, only: %i[show update destroy]

  # @route GET /stories/new (new_story)
  def new
    authorize! Story

    @story = Story.new
  end

  # @route POST /stories (stories)
  def create
    authorize! Story

    @story = Story.new(story_params)

    if @story.save
      case mode
      when :dropper
        GenerateDropperStoryJob.perform_later(@story)

        notice = 'Le premier chapitre de cette nouvelle aventure est en cours de création'
      when :complete
        GenerateFullStoryJob.perform_later(@story)

        notice = "L'aventure pré-générée est en cours de création, veuillez patienter le temps que ChatGPT et Replicate finissent de tout générer."
      end

      respond_to do |format|
        format.html { redirect_to root_path, notice: notice }
        format.turbo_stream { flash[:notice] = notice }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # @route GET /stories/:id (story)
  def show
    authorize! @story
  end

  # @route PATCH /stories/:id (story)
  # @route PUT /stories/:id (story)
  def update
    authorize! @story

    @story.toggle!(:enabled)

    respond_to do |format|
      notice = "L'aventure a bien été mise à jour"

      format.html { redirect_to root_path, notice: notice }
      format.turbo_stream { flash.now[:notice] = notice }
    end
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
    params.require(:story)
          .permit(
            :mode, :publication_rule,
            :nostr_user_id, :thematic_id,
            character_ids: [], place_ids: [],
            options: %i[
              minimum_chapters_count maximum_chapters_count
              minimum_poll_sats maximum_poll_sats
              stable_diffusion_prompt
              stable_diffusion_negative_prompt
              publish_previous
              chatgpt_full_story_system_prompt
              chatgpt_dropper_story_system_prompt
            ]
          )
  end

  def mode
    story_params[:mode].to_sym
  end
end
