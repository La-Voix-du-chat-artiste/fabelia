module Relays
  class ResetListPolicy < ApplicationPolicy
    pre_check :allow_super_admins

    def create?
      true
    end
  end
end
