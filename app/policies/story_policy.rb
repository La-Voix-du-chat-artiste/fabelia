class StoryPolicy < ApplicationPolicy
  pre_check :allow_admins

  def new?
    true
  end

  def create?
    true
  end

  def show?
    true
  end

  def update?
    !story.ended?
  end

  def destroy?
    true
  end

  private

  def story
    record
  end
end
