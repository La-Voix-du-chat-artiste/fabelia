class NostrPublisherService < ApplicationService
  attr_reader :chapter

  def initialize(chapter)
    @chapter = chapter
  end

  def call
    if chapter.first_to_publish?
      reference = NostrFrontCoverPublisherService.call(story, nostr_user)
      story.nostr_identifier = reference
      story.save!
    else
      reference = chapter.last_published.nostr_identifier
    end

    nostr_event_identifier = NostrChapterPublisherService.call(
      chapter, nostr_user, reference
    )

    chapter.update!(
      nostr_identifier: nostr_event_identifier,
      published_at: Time.current
    )

    sleep 1

    return unless adventure_ended?

    story.ended!

    NostrBackCoverPublisherService.call(nostr_user, chapter.nostr_identifier)
  end

  private

  def story
    chapter.story
  end

  def adventure_ended?
    (story.complete? && chapter.last_to_publish?) ||
      (story.dropper? && chapter.adventure_ended?)
  end

  def nostr_user
    @nostr_user ||= NostrUser.find_by!(language: story.language)
  end
end
