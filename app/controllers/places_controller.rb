class PlacesController < ApplicationController
  before_action :set_place, only: %i[edit update destroy]

  # @route GET /places (places)
  def index
    authorize! Place

    @places = Place.all.order(id: :desc)
  end

  # @route GET /places/new (new_place)
  def new
    authorize! Place

    @place = Place.new
  end

  # @route POST /places (places)
  def create
    authorize! Place

    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to places_path, notice: 'Le lieu a bien été ajouté', status: :see_other }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # @route GET /places/:id/edit (edit_place)
  def edit
    authorize! @place
  end

  # @route PATCH /places/:id (place)
  # @route PUT /places/:id (place)
  def update
    authorize! @place

    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to places_path, notice: 'Le lieu a bien été modifié', status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /places/:id (place)
  def destroy
    authorize! @place

    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_path, notice: 'Le lieu a bien été supprimé', status: :see_other }
    end
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(:name, :description, :enabled, :photo)
  end
end
