module Chapters
  class CoverPolicy < ApplicationPolicy
    def update?
      !chapter.published?
    end

    private

    def chapter
      record
    end
  end
end
