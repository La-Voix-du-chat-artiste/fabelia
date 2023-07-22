module NostrServices
  class TextNoteEvent < NostrEvent
    EVENT_KIND = 1 # NIP-1

    attr_reader :chapter, :manual_body, :reference

    def initialize(chapter, manual_body = nil, reference = nil)
      @chapter = chapter
      @manual_body = manual_body
      @reference = reference
    end

    def call
      nostr.build_event(payload).tap do |event|
        nostr.test_post_event(event, relay_url)
      end
    end

    private

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
        ['p', public_key, relay_url]
      ].tap do |data|
        data.push ['e', reference, relay_url] if reference
      end
    end

    def body
      return manual_body if manual_body

      <<~CONTENT
        #{chapter.title}

        #{chapter.content}

        #{chapter.replicate_cover}
      CONTENT
    end
  end
end
