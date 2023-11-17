class SettingPolicy < ApplicationPolicy
  pre_check :allow_super_admins

  def edit?
    update?
  end

  def update?
    true
  end
end
