module Stories
  class ChapterPolicy < ApplicationPolicy
    authorize :story

    pre_check :allow_admins
    pre_check :from_company?, except: :create?
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

    # Override `from_company?` to reference story as record
    def from_company?
      deny! unless story.company_id == user.company_id
    end
  end
end
