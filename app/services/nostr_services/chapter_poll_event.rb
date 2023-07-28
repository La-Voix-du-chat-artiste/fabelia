module NostrServices
  class ChapterPollEvent < NostrEvent
    EVENT_KIND = 6969 # NIP-69
    MINIMUM_SATS_VALUE = 42
    MAXIMUM_SATS_VALUE = 420
    POLL_END_OF_LIFE = 1.hour

    attr_reader :chapter, :reference

    def initialize(chapter, reference)
      @chapter = chapter
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

        #{I18n.t('chapter_poll.poll_choice', locale: locale)}
      CONTENT
    end

    def options
      chapter.options
    end

    def locale
      {
        french: :fr,
        english: :en
      }[chapter.story.language.to_sym] || :fr
    end

    def nostr_user
      chapter.story.nostr_user
    end
  end
end
