module Chapters
  class CoverPolicy < ApplicationPolicy
    pre_check :allow_admins

    def update?
      chapter.story.enabled? && !chapter.published?
    end

    private

    def chapter
      record
    end
  end
end
