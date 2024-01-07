class PromptsController < ApplicationController
  before_action :set_prompt, only: %i[edit update destroy archive]

  # @route GET /prompts (prompts)
  def index
    authorize! Prompt

    @prompts = if params[:archived].to_bool
      company.prompts.archived
    else
      company.prompts.available
    end
  end

  # @route GET /prompts/new (new_prompt)
  def new
    authorize! Prompt

    begin
      type = Base64.decode64(params[:type])
    rescue StandardError
      type = nil
    end

    allowed_types = %w[NarratorPrompt MediaPrompt AtmospherePrompt]

    if params[:type].present? && allowed_types.include?(type)
      @prompt = type.constantize.new
    else
      type = Base64.encode64('NarratorPrompt')
      redirect_to new_prompt_path(type: type)
    end
  end

  # @route POST /prompts (prompts)
  def create
    authorize! Prompt

    type = Base64.decode64(params[:type]) if params[:type].present?

    prompt_params = case type
                    when 'MediaPrompt' then media_prompt_params
                    when 'NarratorPrompt' then narrator_prompt_params
                    when 'AtmospherePrompt' then atmosphere_prompt_params
                    else
                      redirect_to new_prompt_path, alert: 'Type de prompt inconnu'
                      return
    end

    @prompt = type.constantize.new(prompt_params) do |prompt|
      prompt.company = company
    end

    respond_to do |format|
      if @prompt.save
        format.html { redirect_to prompts_path, notice: 'Le prompt a bien été créé.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # @route GET /prompts/:id/edit (edit_prompt)
  def edit
    authorize! @prompt, with: PromptPolicy
  end

  # @route PATCH /prompts/:id (prompt)
  # @route PUT /prompts/:id (prompt)
  def update
    authorize! @prompt, with: PromptPolicy

    prompt_params = case @prompt.type
                    when 'MediaPrompt' then media_prompt_params
                    when 'NarratorPrompt' then narrator_prompt_params
                    when 'AtmospherePrompt' then atmosphere_prompt_params
    end

    respond_to do |format|
      if @prompt.update(prompt_params)
        format.html { redirect_to prompts_path, notice: 'Le prompt a été mis à jour avec succès.', status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /prompts/:id (prompt)
  def destroy
    authorize! @prompt, with: PromptPolicy

    @prompt.destroy

    respond_to do |format|
      notice = 'Le prompt a bien été supprimé.'

      format.html { redirect_to prompts_path, notice: notice }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  # @route POST /prompts/:id/archive (archive_prompt)
  def archive
    authorize! @prompt, with: PromptPolicy

    if @prompt.available?
      @prompt.archive!
      flash[:notice] = 'Le prompt a bien été archivé'
    else
      @prompt.unarchive!
      flash[:notice] = 'Le prompt a bien été désarchivé'
    end

    redirect_to prompts_path
  end

  private

  def set_prompt
    @prompt = company.prompts.find(params[:id])
  end

  def media_prompt_params
    params.require(:media_prompt).permit(
      :title, :body, :negative_body, :enabled, :position,
      options: %i[num_inference_steps]
    )
  end

  def narrator_prompt_params
    params.require(:narrator_prompt).permit(
      :title, :body, :negative_body, :enabled, :position
    )
  end

  def atmosphere_prompt_params
    params.require(:atmosphere_prompt).permit(
      :title, :body, :negative_body, :enabled, :position
    )
  end
end
