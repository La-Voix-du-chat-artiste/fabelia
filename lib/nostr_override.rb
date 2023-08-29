# :nocov:
# Override nostr-ruby gem methods
class Nostr
  def build_metadata_event(opts = {})
    data = opts.slice(
      :name, :about, :picture, :banner, :nip05, :lud16, :website
    )

    event = {
      pubkey: @public_key,
      created_at: Time.now.utc.to_i,
      kind: 0,
      tags: [],
      content: data.to_json
    }

    build_event(event)
  end

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
# :nocov:
