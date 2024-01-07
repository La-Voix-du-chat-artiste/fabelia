class RelayPolicy < ApplicationPolicy
  pre_check :allow_super_admins
  pre_check :from_company?, except: %i[index? new? create?]

  def index?
    true
  end

  def new?
    create?
  end

  def create?
    true
  end

  def edit?
    update?
  end

  def update?
    true
  end

  def destroy?
    true
  end
end
