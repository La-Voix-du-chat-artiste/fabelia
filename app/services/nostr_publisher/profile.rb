module NostrPublisher
  class Profile < ApplicationService
    attr_reader :nostr_user

    def initialize(nostr_user)
      @nostr_user = nostr_user
    end

    def call
      @event = NostrBuilder::ProfileMetadataEvent.call(nostr_user)

      NostrBroadcaster.call(nostr_user, @event)

      finish
    end

    private

    def finish
      content = JSON.parse(@event.last[:content])
      nostr_user.update(metadata_response: content)
    end
  end
end
