module NostrServices
  class ChapterTextNoteEvent < TextNoteEvent
    attr_reader :chapter, :nostr_user, :reference

    def initialize(chapter, nostr_user, reference = nil)
      @chapter = chapter
      @nostr_user = nostr_user
      @reference = reference
    end

    private

    def story
      chapter.story
    end

    def body
      <<~CONTENT
        #{chapter.title}

        #{chapter.content}

        #{chapter.replicate_cover}
        #{extra_body}
      CONTENT
    end

    def extra_body
      return if chapter == story.chapters.last
      return if chapter.options.blank?

      <<~EXTRABODY

        Comment l'aventure va-t-elle continuer ?
        #{chapter.options.map { |v| "• #{v}" }.join("\n")}

        Pour le savoir, ne rate pas le prochain chapitre ! 📖
      EXTRABODY
    end
  end
end
