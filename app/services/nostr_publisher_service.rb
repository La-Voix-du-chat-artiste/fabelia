class NostrPublisherService < ApplicationService
  attr_reader :chapter

  def initialize(chapter)
    @chapter = chapter
  end

  def call
    reference = if chapter.first_to_publish?
      NostrFrontCoverPublisherService.call(story)
    else
      chapter.last_published.nostr_identifier
    end

    nostr_event_identifier = NostrChapterPublisherService.call(
      chapter, reference
    )

    chapter.update!(
      nostr_identifier: nostr_event_identifier,
      published_at: Time.current
    )

    return unless adventure_ended?

    story.ended!

    NostrBackCoverPublisherService.call(chapter.nostr_identifier)
  end

  private

  def story
    chapter.story
  end

  def adventure_ended?
    (story.complete? && chapter.last_published?) ||
      (story.dropper? && chapter.adventure_ended?)
  end
end
