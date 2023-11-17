module NostrBuilder
  class ChapterTextNoteEvent < BaseEvent
    attr_reader :chapter, :reference

    def initialize(chapter, reference = nil)
      @chapter = chapter
      @reference = reference
    end

    def call
      TextNoteEvent.call(body, nostr_user, reference)
    end

    private

    def story
      chapter.story
    end

    def body
      I18n.with_locale(story.language) do
        <<~CONTENT
          #{chapter.title}

          #{chapter.content}

          #{chapter.replicate_cover}
          #{extra_body}
        CONTENT
      end
    end

    def extra_body
      return if chapter == story.chapters.last
      return if chapter.options.blank?

      <<~CONTENT
        #{I18n.t('chapters.text_note.next_adventure_questions').sample}

        #{I18n.t('chapters.text_note.complete_extra_body_content', options: formatted_options)}
      CONTENT
    end

    def formatted_options
      chapter.options.map { |v| "• #{v}" }.join("\n")
    end

    def nostr_user
      story.nostr_user
    end
  end
end
