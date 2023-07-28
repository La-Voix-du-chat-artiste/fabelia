class NostrChapterPublisherService < ApplicationService
  attr_reader :chapter, :reference

  def initialize(chapter, reference)
    @chapter = chapter
    @reference = reference
  end

  def call
    event = if story.dropper? && !chapter.adventure_ended?
      NostrServices::ChapterPollEvent.call(chapter, reference)
    else
      NostrServices::ChapterTextNoteEvent.call(chapter, reference)
    end

    debug_logger('Nostr Chapter', event.inspect, :green)

    event.last['id']
  end

  private

  def story
    chapter.story
  end
end
