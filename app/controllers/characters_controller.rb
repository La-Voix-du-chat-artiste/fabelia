class CharactersController < ApplicationController
  before_action :set_character, only: %i[edit update destroy]

  # @route GET /characters (characters)
  def index
    authorize! Character

    @characters = Character.order(id: :desc)
  end

  # @route GET /characters/new (new_character)
  def new
    authorize! Character

    @character = Character.new
  end

  # @route POST /characters (characters)
  def create
    authorize! Character

    @character = Character.new(character_params)

    respond_to do |format|
      if @character.save
        format.html { redirect_to characters_path, notice: 'Le personnage a bien été créé', status: :see_other }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # @route GET /characters/:id/edit (edit_character)
  def edit
    authorize! @character
  end

  # @route PATCH /characters/:id (character)
  # @route PUT /characters/:id (character)
  def update
    authorize! @character

    respond_to do |format|
      if @character.update(character_params)
        format.html { redirect_to characters_path, notice: 'Le personnage a bien été mis à jour', status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /characters/:id (character)
  def destroy
    authorize! @character

    @character.destroy

    respond_to do |format|
      format.html { redirect_to characters_path, notice: 'Le personnage a bien été supprimé', status: :see_other }
    end
  end

  private

  def set_character
    @character = Character.find(params[:id])
  end

  def character_params
    params.require(:character).permit(
      :first_name, :last_name, :biography, :enabled, :avatar
    )
  end
end
