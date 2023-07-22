class NostrChapterPublisherService < ApplicationService
  attr_reader :chapter, :reference

  def initialize(chapter, reference)
    @chapter = chapter
    @reference = reference
  end

  def call
    event = if story.dropper?
      NostrServices::PollEvent.call(chapter, reference)
    else
      NostrServices::TextNoteEvent.call(chapter, nil, reference)
    end

    debug_logger('Nostr Chapter', event.inspect, :green)

    event.last['id']
  end

  private

  def story
    chapter.story
  end
end
