module NostrServices
  class ChapterPollEvent < NostrEvent
    EVENT_KIND = 6969 # NIP-69
    POLL_END_OF_LIFE = 1.hour

    attr_reader :chapter, :reference

    def initialize(chapter, reference)
      @chapter = chapter
      @reference = reference
    end

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
        ['p', public_key, favorite_relay_url],
        ['value_minimum', options.minimum_poll_sats.to_s],
        ['value_maximum', options.maximum_poll_sats.to_s],
        ['closed_at', POLL_END_OF_LIFE.from_now.utc.to_i.to_s]
      ].tap do |data|
        data.push ['e', reference, favorite_relay_url] if reference

        chapter.options.each_with_index do |option, index|
          data.push ['poll_option', index.to_s, option]
        end
      end
    end

    def body
      <<~CONTENT
        #{chapter.title}

        #{chapter.content}

        #{chapter.replicate_cover}

        #{I18n.t('chapter_poll.poll_choice')}
      CONTENT
    end

    def nostr_user
      chapter.story.nostr_user
    end
  end
end
