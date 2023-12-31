module NostrUsers
  class RefreshProfilesController < ApplicationController
    before_action :set_nostr_user

    # @route POST /nostr_users/:id/refresh_profiles (refresh_profiles)
    def create
      authorize! @nostr_user, with: ProfilePolicy

      NostrServices::ImportProfile.call(@nostr_user)

      redirect_to nostr_users_path, notice: 'Les métadonnées du profil ont bien été rafraîchies'
    rescue URI::InvalidURIError,
           Errno::ECONNREFUSED,
           NostrUserErrors::MissingFavoriteRelay,
           OpenSSL::SSL::SSLError => e
      redirect_to nostr_users_path, alert: e.message
    end

    private

    def set_nostr_user
      @nostr_user = company.nostr_users.find(params[:id])
    end
  end
end
