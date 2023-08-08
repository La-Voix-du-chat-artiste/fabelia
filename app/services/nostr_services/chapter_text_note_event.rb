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

      I18n.t('chapters.text_note.complete_extra_body_content', options: formatted_options, locale: story.language)
    end

    def formatted_options
      chapter.options.map { |v| "• #{v}" }.join("\n")
    end

    def nostr_user
      story.nostr_user
    end
  end
end
