module NostrServices
  # @see https://github.com/nostr-protocol/nips/blob/master/09.md
  class StoryDeletionEvent < NostrEvent
    EVENT_KIND = 5 # NIP-9

    attr_reader :story

    def initialize(story)
      @story = story
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
      [].tap do |data|
        data.push ['e', story.nostr_identifier] if story.front_cover_pubished?
        data.push ['e', story.back_cover_nostr_identifier] if story.back_cover_published?

        story.chapters.published.each do |chapter|
          data.push ['e', chapter.nostr_identifier]
        end
      end
    end

    def body
      ''
    end

    def nostr_user
      story.nostr_user
    end
  end
end
