module NostrBuilder
  class ChapterPollEvent < BaseEvent
    EVENT_KIND = 6969 # NIP-69
    POLL_END_OF_LIFE = 1.hour

    attr_reader :chapter, :reference

    def initialize(chapter, reference)
      @chapter = chapter
      @reference = reference
    end

    def call
      nostr.build_event(payload)
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
        ['p', public_key],
        ['value_minimum', options.minimum_poll_sats.to_s],
        ['value_maximum', options.maximum_poll_sats.to_s],
        ['closed_at', POLL_END_OF_LIFE.from_now.utc.to_i.to_s]
      ].tap do |data|
        data.push ['e', reference] if reference

        chapter.options.each_with_index do |option, index|
          data.push ['poll_option', index.to_s, option]
        end
      end
    end

    def body
      I18n.with_locale(story.language) do
        <<~CONTENT
          #{chapter.title}

          #{chapter.content}

          #{chapter.replicate_cover}
          #{I18n.t('chapters.poll_note.next_adventure_questions').sample}
        CONTENT
      end
    end

    def nostr_user
      story.nostr_user
    end

    def story
      chapter.story
    end

    def options
      @options ||= story.options
    end
  end
end
