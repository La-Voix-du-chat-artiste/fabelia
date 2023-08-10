class StoryPolicy < ApplicationPolicy
  def create?
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
