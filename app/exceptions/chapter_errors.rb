class ChapterErrors < BaseErrors
  EmptyPollOptions = Class.new(self)
  MissingPollOptions = Class.new(self)
  FullStoryMissingChapters = Class.new(self)

  ChapterAlreadyPublished = Class.new(self) do
    attr_reader :chapter

    def initialize(chapter:)
      super()

      @chapter = chapter
    end

    def message
      I18n.t(
        class_name,
        chapter_position: chapter.position,
        chapter_title: chapter.title,
        scope: i18n_scope
      )
    end
  end

  PreviousChapterNotPublished = Class.new(self) do
    attr_reader :chapter, :previous_chapter

    def initialize(chapter, previous_chapter)
      super()

      @chapter = chapter
      @previous_chapter = previous_chapter
    end

    def message
      I18n.t(
        class_name,
        story_id: chapter.story.id,
        story_title: chapter.story.title,
        chapter_position: chapter.position,
        chapter_title: chapter.title,
        previous_chapter_position: previous_chapter.position,
        previous_chapter_title: previous_chapter.title,
        scope: i18n_scope
      )
    end
  end
end
