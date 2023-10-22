class PromptPolicy < ApplicationPolicy
  pre_check :allow_admins

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
    return false if record.stories_count >= 1

    record.class.count > 1
  end

  def archive?
    true
  end
end
