class NostrBackCoverPublisherService < ApplicationService
  attr_reader :chapter

  def initialize(chapter)
    @chapter = chapter
  end

  def call
    event = NostrServices::ManualTextNoteEvent.call(body, nostr_user, reference)

    debug_logger('Nostr Back cover', event.inspect, :green)

    event.last['id']
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
