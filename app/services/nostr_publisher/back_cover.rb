module NostrPublisher
  class BackCover < ApplicationService
    include Rails.application.routes.url_helpers

    attr_reader :chapter

    def initialize(chapter)
      @chapter = chapter
    end

    def call
      event = NostrBuilder::TextNoteEvent.call(body, nostr_user, reference)

      debug_logger('Nostr Back cover', event.inspect, :green)

      NostrBroadcaster.call(nostr_user, event)
    end

    private

    def body
      return main_body unless options.read_as_pdf?

      pdf_url = public_story_url(
        Base64.strict_encode64("#{story.id}-#{story.title}"),
        format: :pdf
      )

      main_body_with_pdf_url(pdf_url)
    end

    def main_body
      <<~BODY
        🔥 📖 🤖

        #{I18n.t('chapters.back_cover.content')}

        https://flownaely.cafe
      BODY
    end

    def main_body_with_pdf_url(pdf_url)
      <<~BODY
        🔥 📖 🤖

        #{I18n.t('chapters.back_cover.content_with_pdf_url', public_pdf_url: pdf_url)}

        https://flownaely.cafe
      BODY
    end

    def nostr_user
      chapter.story.nostr_user
    end

    def reference
      chapter.nostr_identifier
    end

    def story
      chapter.story
    end

    def options
      story.options
    end
  end
end
