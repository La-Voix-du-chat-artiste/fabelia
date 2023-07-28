class NostrFrontCoverPublisherService < ApplicationService
  attr_reader :story

  def initialize(story)
    @story = story
  end

  def call
    event = NostrServices::ManualTextNoteEvent.call(body, nostr_user)

    debug_logger('Nostr Front cover', event.inspect, :green)

    event.last['id']
  end

  private

  def body
    <<~FRONTCOVER
      #{story.title}

      #{story.replicate_cover}
    FRONTCOVER
  end

  def nostr_user
    story.nostr_user
  end
end
