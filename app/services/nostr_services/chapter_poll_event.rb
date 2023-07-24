module NostrServices
  class ChapterPollEvent < NostrEvent
    EVENT_KIND = 6969 # NIP-69
    MINIMUM_SATS_VALUE = 42
    MAXIMUM_SATS_VALUE = 420
    POLL_END_OF_LIFE = 1.hour

    attr_reader :chapter, :nostr_user, :reference

    def initialize(chapter, nostr_user, reference)
      @chapter = chapter
      @nostr_user = nostr_user
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
        ['p', public_key, relay_url],
        ['value_minimum', MINIMUM_SATS_VALUE.to_s],
        ['value_maximum', MAXIMUM_SATS_VALUE.to_s],
        ['closed_at', POLL_END_OF_LIFE.from_now.utc.to_i.to_s]
      ].tap do |data|
        data.push ['e', reference, relay_url] if reference

        options.each_with_index do |option, index|
          data.push ['poll_option', index.to_s, option]
        end
      end
    end

    def body
      <<~CONTENT
        #{chapter.title}

        #{chapter.content}

        #{chapter.replicate_cover}

        Quelle doit être la suite de l'aventure ?
      CONTENT
    end

    def options
      chapter.options
    end
  end
end
