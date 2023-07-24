module NostrServices
  class ChapterTextNoteEvent < TextNoteEvent
    attr_reader :chapter, :nostr_user, :reference

    def initialize(chapter, nostr_user, reference = nil)
      @chapter = chapter
      @nostr_user = nostr_user
      @reference = reference
    end

    private

    def body
      <<~CONTENT
        #{chapter.title}

        #{chapter.content}

        #{chapter.replicate_cover}
      CONTENT
    end
  end
end
