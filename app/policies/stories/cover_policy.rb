module Stories
  class CoverPolicy < ApplicationPolicy
    pre_check :allow_admins
    pre_check :from_company?

    def update?
      story.enabled? && !story.current? && !story.ended?
    end

    private

    def story
      record
    end
  end
end
