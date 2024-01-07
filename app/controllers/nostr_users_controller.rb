class NostrUsersController < ApplicationController
  before_action :set_nostr_user, only: %i[edit update destroy]

  # @route GET /nostr_users (nostr_users)
  def index
    authorize! NostrUser

    @nostr_users = company.nostr_users.order(id: :asc)
  end

  # @route GET /nostr_users/new (new_nostr_user)
  def new
    authorize! NostrUser

    @nostr_user = company.nostr_users.new(mode: :generated)
  end

  # @route POST /nostr_users (nostr_users)
  def create
    authorize! NostrUser

    @nostr_user = company.nostr_users.new(nostr_user_create_params) do |nostr_user|
      nostr_user.mode = :generated
      nostr_user.relays = [Relay.main]
    end

    if @nostr_user.save
      NostrPublisher::Profile.call_later(@nostr_user)

      redirect_to nostr_users_path, notice: "Votre compte Nostr vient d'être créé ! ⚠️ Assurez-vous d'avoir fait une sauvegarde de votre clé privée pour ne pas perdre votre compte ⚠️"
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

    if @nostr_user.update(nostr_user_update_params)
      NostrPublisher::Profile.call_later(@nostr_user)

      redirect_to nostr_users_path, notice: 'Le compte Nostr a bien été mis à jour.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # @route DELETE /nostr_users/:id (nostr_user)
  def destroy
    authorize! @nostr_user

    @nostr_user.destroy

    respond_to do |format|
      notice = 'Le compte Nostr a bien été supprimé.'

      format.html { redirect_to nostr_users_path, notice: notice }
      format.turbo_stream { flash.now[:notice] = notice }
    end
  end

  private

  def set_nostr_user
    @nostr_user = company.nostr_users.find(params[:id])
  end

  def nostr_user_create_params
    nostr_user_update_params.merge(
      params.require(:nostr_user).permit(:language)
    )
  end

  def nostr_user_update_params
    params.require(:nostr_user)
          .permit(:name, :display_name, :about, :nip05, :lud16,
                  :website, :picture, :banner, :enabled,
                  relay_ids: [])
  end
end
