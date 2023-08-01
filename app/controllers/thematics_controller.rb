class ThematicsController < ApplicationController
  before_action :set_thematic, only: %i[show edit update destroy]

  # GET /thematics or /thematics.json
  # @route GET /thematics (thematics)
  def index
    @thematics = Thematic.all
  end

  # @route GET /thematics/new (new_thematic)
  def new
    @thematic = Thematic.new
  end

  # POST /thematics or /thematics.json
  # @route POST /thematics (thematics)
  def create
    @thematic = Thematic.new(thematic_params)

    respond_to do |format|
      if @thematic.save
        format.html { redirect_to thematic_path(@thematic), notice: 'Thematic was successfully created.' }
        format.json { render :show, status: :created, location: @thematic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @thematic.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /thematics/1 or /thematics/1.json
  # @route GET /thematics/:id (thematic)
  def show
  end

  # @route GET /thematics/:id/edit (edit_thematic)
  def edit
  end

  # PATCH/PUT /thematics/1 or /thematics/1.json
  # @route PATCH /thematics/:id (thematic)
  # @route PUT /thematics/:id (thematic)
  def update
    respond_to do |format|
      if @thematic.update(thematic_params)
        format.html { redirect_to thematic_path(@thematic), notice: 'Thematic was successfully updated.' }
        format.json { render :show, status: :ok, location: @thematic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @thematic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /thematics/1 or /thematics/1.json
  # @route DELETE /thematics/:id (thematic)
  def destroy
    @thematic.destroy

    respond_to do |format|
      format.html { redirect_to thematics_path, notice: 'Thematic was successfully destroyed.' }
      format.json { head :no_content }
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
