class StoryPolicy < ApplicationPolicy
  pre_check :allow_admins
  pre_check :from_company?, except: %i[new? create?]

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
