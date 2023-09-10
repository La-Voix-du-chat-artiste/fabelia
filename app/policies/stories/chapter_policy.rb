module Stories
  class ChapterPolicy < ApplicationPolicy
    authorize :story

    pre_check :allow_admins
    pre_check :story_enabled?, except: :show?

    def create?
      true
    end

    def show?
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
    end
  end
end
