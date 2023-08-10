module NostrUsers
  class RefreshProfilesController < ApplicationController
    before_action :set_nostr_user

    # @route POST /nostr_users/:id/refresh_profiles (refresh_profiles)
    def create
      authorize! @nostr_user, with: NostrUsers::ProfilePolicy

      response = NostrServices::FetchProfile.call(@nostr_user)

      @nostr_user.update(metadata_response: response)

      redirect_to nostr_users_path, notice: 'Les métadonnées du profil ont bien été rafraîchies'
    end

    private

    def set_nostr_user
      @nostr_user = NostrUser.find(params[:id])
    end
  end
end
