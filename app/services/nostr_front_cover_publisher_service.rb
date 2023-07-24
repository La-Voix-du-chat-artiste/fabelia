class NostrFrontCoverPublisherService < ApplicationService
  attr_reader :story, :nostr_user

  def initialize(story, nostr_user)
    @story = story
    @nostr_user = nostr_user
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
end
