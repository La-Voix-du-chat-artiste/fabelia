module NostrServices
  class ChapterTextNoteEvent < TextNoteEvent
    attr_reader :chapter, :reference

    def initialize(chapter, reference = nil)
      @chapter = chapter
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

    def nostr_user
      story.nostr_user
    end
  end
end
