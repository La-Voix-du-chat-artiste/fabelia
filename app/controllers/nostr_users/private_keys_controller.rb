module NostrUsers
  class PrivateKeysController < ApplicationController
    before_action :set_nostr_user

    # @route GET /nostr_users/:id/private_keys/ask_password (ask_password_private_keys)
    def ask_password
      authorize! @nostr_user, with: PrivateKeyPolicy
    end

    # @route POST /nostr_users/:id/private_keys/reveal (reveal_private_keys)
    def reveal
      authorize! @nostr_user, with: PrivateKeyPolicy

      if current_user.valid_password?(user_password)
        nostr = Nostr.new(private_key: @nostr_user.private_key)
        @nsec = nostr.bech32_keys[:private_key]
      else
        @nostr_user.errors.add(:user_password, 'Mot de passe invalide')

        render :ask_password, status: :unprocessable_entity
      end
    end

    private

    def nostr_user_params
      params.require(:nostr_user).permit(:user_password)
    end

    def user_password
      nostr_user_params[:user_password]
    end

    def set_nostr_user
      @nostr_user = company.nostr_users.find(params[:id])
    end
  end
end
