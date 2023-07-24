module NostrServices
  class ManualTextNoteEvent < TextNoteEvent
    attr_reader :body, :nostr_user, :reference

    def initialize(body, nostr_user, reference = nil)
      @body = body
      @nostr_user = nostr_user
      @reference = reference
    end
  end
end
