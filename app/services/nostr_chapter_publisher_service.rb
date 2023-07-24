class NostrChapterPublisherService < ApplicationService
  attr_reader :chapter, :nostr_user, :reference

  def initialize(chapter, nostr_user, reference)
    @chapter = chapter
    @nostr_user = nostr_user
    @reference = reference
  end

  def call
    event = if story.dropper?
      NostrServices::ChapterPollEvent.call(chapter, nostr_user, reference)
    else
      NostrServices::ChapterTextNoteEvent.call(chapter, nostr_user, reference)
    end

    debug_logger('Nostr Chapter', event.inspect, :green)

    event.last['id']
  end

  private

  def story
    chapter.story
  end
end
