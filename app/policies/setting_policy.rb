class SettingPolicy < ApplicationPolicy
  pre_check :allow_super_admins
  pre_check :from_company?

  def edit?
    update?
  end

  def update?
    true
  end
end
