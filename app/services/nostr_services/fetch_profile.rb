module NostrServices
  class FetchProfile < NostrEvent
    METADATA_KIND = 0

    attr_reader :nostr_user

    def initialize(nostr_user)
      @nostr_user = nostr_user
    end

    def call
      req = nostr.build_req_event(filters)

      test_post_event(req, favorite_relay_url)
    end

    private

    def filters
      { kinds: [METADATA_KIND], authors: [public_key], limit: 1 }
    end

    # NOTE: This method has been extracted from `nostr_ruby` gem to fix
    # a crash with invalid encoding characters.
    def test_post_event(event, relay)
      response = nil
      ws = WebSocket::Client::Simple.connect(relay)

      ws.on :open do
        ws.send event.to_json
      end

      ws.on :message do |msg|
        response = JSON.parse(msg.data.force_encoding('UTF-8'))
        ws.close
      end

      ws.on :error do |e|
        debug_logger('WebSocket Error', e, :red)
        ws.close
      end

      sleep 0.1 while response.nil?

      response
    end
  end
end
