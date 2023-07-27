module Chapters
  class CoverPolicy < ApplicationPolicy
    def update?
      !record.published?
    end
  end
end
