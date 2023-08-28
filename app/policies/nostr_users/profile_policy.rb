module NostrUsers
  class ProfilePolicy < ApplicationPolicy
    pre_check :allow_admins

    def create?
      nostr_user.enabled?
    end

    private

    def nostr_user
      record
    end
  end
end
