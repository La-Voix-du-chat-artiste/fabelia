module NostrServices
  class TextNoteEvent < NostrEvent
    EVENT_KIND = 1 # NIP-1

    def call
      validate!

      nostr.build_event(payload).tap do |event|
        relay_urls.each do |relay_url|
          nostr.test_post_event(event, relay_url)
        end
      end
    end

    private

    def validate!
      raise NostrUserErrors::MissingAssociatedRelay if relay_urls.empty?
    end

    def payload
      @payload ||= {
        kind: EVENT_KIND,
        pubkey: public_key,
        created_at: created_at,
        tags: tags,
        content: body
      }
    end

    def tags
      [
        ['p', public_key, '']
      ].tap do |data|
        data.push ['e', reference, ''] if reference
      end
    end
  end
end
