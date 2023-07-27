module Stories
  class CoverPolicy < ApplicationPolicy
    def update?
      record.adventure_ended_at.nil? &&
        record.chapters.published.none?
    end
  end
end
