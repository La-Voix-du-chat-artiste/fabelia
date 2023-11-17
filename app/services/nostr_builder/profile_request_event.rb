module NostrBuilder
  class ProfileRequestEvent < BaseEvent
    METADATA_KIND = 0

    attr_reader :nostr_user

    def initialize(nostr_user)
      @nostr_user = nostr_user
    end

    def call
      validate!

      event = nostr.build_req_event(filters)
      response = nostr.test_post_event(event, favorite_relay_url)

      JSON.parse(response.last['content'])
    end

    private

    def validate!
      raise NostrUserErrors::MissingFavoriteRelay if favorite_relay_url.blank?
    end

    def filters
      { kinds: [METADATA_KIND], authors: [public_key], limit: 1 }
    end
  end
end
