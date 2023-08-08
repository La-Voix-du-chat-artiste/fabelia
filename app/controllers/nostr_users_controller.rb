class NostrUsersController < ApplicationController
  before_action :set_nostr_user, only: %i[edit update destroy]

  # @route GET /nostr_users (nostr_users)
  def index
    @nostr_users = NostrUser.all
  end

  # @route GET /nostr_users/new (new_nostr_user)
  def new
    @nostr_user = NostrUser.new
  end

  # @route POST /nostr_users (nostr_users)
  def create
    @nostr_user = NostrUser.new(nostr_user_params)

    respond_to do |format|
      if @nostr_user.save
        format.html { redirect_to nostr_users_path, notice: 'Nostr user was successfully created.' }
        format.json { render :show, status: :created, location: @nostr_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @nostr_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route GET /nostr_users/:id/edit (edit_nostr_user)
  def edit
  end

  # @route PATCH /nostr_users/:id (nostr_user)
  # @route PUT /nostr_users/:id (nostr_user)
  def update
    respond_to do |format|
      if @nostr_user.update(nostr_user_params)
        format.html { redirect_to nostr_users_path, notice: 'Nostr user was successfully updated.' }
        format.json { render :show, status: :ok, location: @nostr_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @nostr_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # @route DELETE /nostr_users/:id (nostr_user)
  def destroy
    @nostr_user.destroy

    respond_to do |format|
      format.html { redirect_to nostr_users_path, notice: 'Nostr user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_nostr_user
    @nostr_user = NostrUser.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def nostr_user_params
    params.require(:nostr_user)
          .permit(
            :name, :public_key, :private_key,
            :relay_url, :language, :avatar, :enabled
          )
  end
end
