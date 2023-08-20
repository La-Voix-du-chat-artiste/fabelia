module Stories
  class CoverPolicy < ApplicationPolicy
    pre_check :allow_admins

    def update?
      story.enabled? && !story.current? && !story.ended?
    end

    private

    def story
      record
    end
  end
end
