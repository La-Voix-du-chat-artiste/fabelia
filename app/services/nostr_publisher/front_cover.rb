module NostrPublisher
  class FrontCover < ApplicationService
    attr_reader :story

    def initialize(story)
      @story = story
    end

    def call
      event = NostrBuilder::TextNoteEvent.call(body, nostr_user)

      debug_logger('Nostr Front cover', event.inspect, :green)

      NostrBroadcaster.call(nostr_user, event)
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
end
