module Public
  class StoryPolicy < ApplicationPolicy
    authorize :user, allow_nil: true

    def show?
      return true if user && admin_up?

      story.options.read_as_pdf? && story.ended?
    end

    private

    def story
      record
    end
  end
end
