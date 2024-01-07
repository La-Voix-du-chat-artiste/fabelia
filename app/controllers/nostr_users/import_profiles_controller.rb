module NostrUsers
  class ImportProfilesController < ApplicationController
    # @route GET /nostr_users/import_profiles/new (new_import_profiles)
    def new
      authorize! NostrUser

      @nostr_user = company.nostr_users.new
    end

    # @route POST /nostr_users/import_profiles (import_profiles)
    def create
      authorize! NostrUser

      @nostr_user = company.nostr_users.new(nostr_user_params) do |nostr_user|
        nostr_user.mode = :imported
      end

      if @nostr_user.save
        NostrServices::ImportAccount.call(@nostr_user)

        redirect_to nostr_users_path, notice: 'Nostr user was successfully imported.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def nostr_user_params
      params.require(:nostr_user)
            .permit(:private_key, :language, :enabled, relay_ids: [])
    end
  end
end
