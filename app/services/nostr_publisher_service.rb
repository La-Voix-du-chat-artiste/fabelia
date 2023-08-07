class NostrPublisherService < ApplicationService
  attr_reader :chapter

  def initialize(chapter)
    @chapter = chapter
  end

  def call
    I18n.with_locale(story.language) do
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

      if adventure_ended?
        story.ended!

        reference = NostrBackCoverPublisherService.call(chapter)
        story.back_cover_nostr_identifier = reference
        story.save!
      end
    end

    true
  end

  private

  def story
    chapter.story
  end

  def adventure_ended?
    (story.complete? && chapter.last_to_publish?) ||
      (story.dropper? && chapter.adventure_ended?)
  end
end
