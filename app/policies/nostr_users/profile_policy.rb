module NostrUsers
  class ProfilePolicy < ApplicationPolicy
    def create?
      nostr_user.enabled?
    end

    private

    def nostr_user
      record
    end
  end
end
