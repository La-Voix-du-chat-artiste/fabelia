module Stories
  class CoverPolicy < ApplicationPolicy
    def update?
      !story.current?
    end

    private

    def story
      record
    end
  end
end
