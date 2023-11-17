module NostrBuilder
  # @see https://github.com/nostr-protocol/nips/blob/master/01.md
  class TextNoteEvent < BaseEvent
    EVENT_KIND = 1

    attr_reader :body, :nostr_user, :reference

    def initialize(body, nostr_user, reference = nil)
      @body = body
      @nostr_user = nostr_user
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
        ['p', public_key]
      ].tap do |data|
        data.push ['e', reference] if reference
      end
    end
  end
end
