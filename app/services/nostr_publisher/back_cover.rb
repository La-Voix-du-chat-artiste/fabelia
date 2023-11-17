module NostrPublisher
  class BackCover < ApplicationService
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
      <<~BACKCOVER
        🔥 📖 🤖

        #{I18n.t('chapters.back_cover.content')}

        https://flownaely.cafe
      BACKCOVER
    end

    def nostr_user
      chapter.story.nostr_user
    end

    def reference
      chapter.nostr_identifier
    end
  end
end
