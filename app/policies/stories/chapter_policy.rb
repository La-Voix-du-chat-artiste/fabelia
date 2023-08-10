module Stories
  class ChapterPolicy < ApplicationPolicy
    authorize :story
    pre_check :story_enabled?

    def create?
      true
    end

    def publish?
      !chapter.published?
    end

    def publish_next?
      !chapter.published?
    end

    def publish_all?
      true
    end

    private

    def chapter
      record
    end

    def story_enabled?
      deny! if !story.enabled? || story.ended?

      allow!
    end
  end
end
