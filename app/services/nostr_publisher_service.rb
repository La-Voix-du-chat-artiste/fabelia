class NostrPublisherService < ApplicationService
  attr_reader :chapter

  def initialize(chapter)
    @chapter = chapter
  end

  def call
    validate!

    @publishable = story.publishable_story?

    I18n.with_locale(story.language) do
      process!
    end

    finish
  end

  private

  def validate!
    raise ChapterErrors::ChapterAlreadyPublished.new(chapter: chapter) if chapter.published?
    raise ChapterErrors::PreviousChapterNotPublished.new(chapter, chapter.previous) if chapter.previous && !chapter.previous.published?
  end

  def process!
    if chapter.first_to_publish?
      reference = NostrFrontCoverPublisherService.call(story)
      story.nostr_identifier = reference
      story.save!
    else
      reference = chapter.last_published.nostr_identifier
    end

    nostr_event_identifier = NostrChapterPublisherService.call(
      chapter, reference
    )

    chapter.update!(
      nostr_identifier: nostr_event_identifier,
      published_at: Time.current
    )

    sleep 1

    return unless adventure_ended?

    story.ended!

    reference = NostrBackCoverPublisherService.call(chapter)
    story.back_cover_nostr_identifier = reference
    story.save!
  end

  def finish
    chapter.broadcast_chapter
    story.broadcast_move_from_current_to_ended if story.ended?
    story.broadcast_next_quick_look_story if @publishable || story.ended?
    story.display_empty_stories unless Story.current?
  end

  def story
    chapter.story
  end

  def adventure_ended?
    (story.complete? && chapter.last_to_publish?) ||
      (story.dropper? && chapter.adventure_ended?)
  end
end
