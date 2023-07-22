class NostrFrontCoverPublisherService < ApplicationService
  attr_reader :story

  def initialize(story)
    @story = story
  end

  def call
    event = NostrServices::TextNoteEvent.call(nil, body)

    debug_logger('Nostr Front cover', event.inspect, :green)

    event.last['id']
  end

  def body
    <<~FRONTCOVER
      #{story.title}

      #{story.replicate_cover}
    FRONTCOVER
  end
end
