class SettingPolicy < ApplicationPolicy
  pre_check :allow_super_admins

  def show?
    true
  end

  def edit?
    update?
  end

  def update?
    true
  end
end
