module Chapters
  class CoverPolicy < ApplicationPolicy
    pre_check :allow_admins
    pre_check :from_company?

    def update?
      chapter.story.enabled? && !chapter.published?
    end

    private

    def chapter
      record
    end

    # Override `from_company?` to reference story as record
    def from_company?
      deny! unless record.story.company_id == user.company_id
    end
  end
end
