class ThematicsController < ApplicationController
  before_action :set_thematic, only: %i[edit update destroy]

  # @route GET /thematics (thematics)
  def index
    authorize! Thematic

    @thematics = Thematic.all
  end

  # @route GET /thematics/new (new_thematic)
  def new
    authorize! Thematic

    @thematic = Thematic.new
  end

  # @route POST /thematics (thematics)
  def create
    authorize! Thematic

    @thematic = Thematic.new(thematic_params)

    respond_to do |format|
      if @thematic.save
        format.html { redirect_to thematics_path, notice: 'Thematic was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # @route GET /thematics/:id/edit (edit_thematic)
  def edit
    authorize! @thematic
  end

  # @route PATCH /thematics/:id (thematic)
  # @route PUT /thematics/:id (thematic)
  def update
    authorize! @thematic

    respond_to do |format|
      if @thematic.update(thematic_params)
        format.html { redirect_to thematics_path, notice: 'Thematic was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /thematics/:id (thematic)
  def destroy
    authorize! @thematic

    @thematic.destroy

    respond_to do |format|
      notice = 'Thematic was successfully destroyed.'

      format.html { redirect_to thematics_path, notice: notice }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_thematic
    @thematic = Thematic.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def thematic_params
    params.require(:thematic).permit(:identifier, :name_fr, :name_en, :description_fr, :description_en, :enabled)
  end
end
