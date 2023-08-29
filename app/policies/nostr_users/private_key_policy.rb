module NostrUsers
  class PrivateKeyPolicy < ApplicationPolicy
    pre_check :allow_super_admins

    def ask_password?
      true
    end

    def reveal?
      true
    end
  end
end
