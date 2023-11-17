module NostrPublisher
  # This service is responsible to publish chapters in a clever way:
  # - Publish front cover before the first story chapter
  # - Publish current chapter (poll or regular note event)
  # - Publish back cover if current chapter is the last one of the story
  class SmartChapter < ApplicationService
    attr_reader :chapter

    # @param chapter [Chapter]
    def initialize(chapter)
      @chapter = chapter
    end

    def call
      validate!

      @publishable = story.publishable_story?

      I18n.with_locale(story.language) do
        front_cover_identifier = handle_front_cover!
        reference = front_cover_identifier || chapter.last_published.nostr_identifier

        handle_chapter!(reference)
        handle_back_cover!
      end

      finish
    end

    private

    def validate!
      raise ChapterErrors::ChapterAlreadyPublished.new(chapter: chapter) if chapter.published?
      raise ChapterErrors::PreviousChapterNotPublished.new(chapter, chapter.previous) if chapter.previous && !chapter.previous.published?
    end

    def finish
      chapter.broadcast_chapter
      story.broadcast_move_from_current_to_ended if story.ended?
      story.broadcast_next_quick_look_story if @publishable || story.ended?
      story.display_empty_stories unless Story.current?
    end

    def handle_front_cover!
      return unless chapter.first_to_publish?

      reference = FrontCover.call(story)
      story.nostr_identifier = reference
      story.save!

      reference
    end

    def handle_chapter!(reference)
      event = if story.dropper? && !chapter.adventure_ended?
        NostrBuilder::ChapterPollEvent.call(chapter, reference)
      else
        NostrBuilder::ChapterTextNoteEvent.call(chapter, reference)
      end

      nostr_event_identifier = NostrBroadcaster.call(story.nostr_user, event)

      chapter.update!(
        nostr_identifier: nostr_event_identifier,
        published_at: Time.current
      )
    end

    def handle_back_cover!
      return unless adventure_ended?

      sleep 1

      story.ended!

      reference = BackCover.call(chapter)
      story.back_cover_nostr_identifier = reference
      story.save!
    end

    def story
      chapter.story
    end

    def adventure_ended?
      (story.complete? && chapter.last_to_publish?) ||
        (story.dropper? && chapter.adventure_ended?)
    end
  end
end
