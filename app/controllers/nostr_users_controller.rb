class NostrUsersController < ApplicationController
  before_action :set_nostr_user, only: %i[edit update destroy]

  # @route GET /nostr_users (nostr_users)
  def index
    authorize! NostrUser

    @nostr_users = NostrUser.all
  end

  # @route GET /nostr_users/new (new_nostr_user)
  def new
    authorize! NostrUser

    @nostr_user = NostrUser.new
  end

  # @route POST /nostr_users (nostr_users)
  def create
    authorize! NostrUser

    @nostr_user = NostrUser.new(nostr_user_params)

    if @nostr_user.save
      redirect_to nostr_users_path, notice: 'Nostr user was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # @route GET /nostr_users/:id/edit (edit_nostr_user)
  def edit
    authorize! @nostr_user
  end

  # @route PATCH /nostr_users/:id (nostr_user)
  # @route PUT /nostr_users/:id (nostr_user)
  def update
    authorize! @nostr_user

    if @nostr_user.update(nostr_user_params)
      redirect_to nostr_users_path, notice: 'Nostr user was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /nostr_users/:id (nostr_user)
  def destroy
    authorize! @nostr_user

    @nostr_user.destroy

    respond_to do |format|
      notice = 'Nostr user was successfully destroyed.'

      format.html { redirect_to nostr_users_path, notice: notice }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  private

  def set_nostr_user
    @nostr_user = NostrUser.find(params[:id])
  end

  def nostr_user_params
    params.require(:nostr_user)
          .permit(:private_key, :language, :enabled, relay_ids: [])
  end
end
