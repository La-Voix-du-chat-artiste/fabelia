class NostrBackCoverPublisherService < ApplicationService
  attr_reader :reference

  def initialize(reference)
    @reference = reference
  end

  def call
    event = NostrServices::TextNoteEvent.call(nil, body, reference)

    debug_logger('Nostr Back cover', event.inspect, :green)
  end

  private

  def body
    <<~BACKCOVER
      🔥 📖 🤖

      Si cette histoire vous a plu, n'hésitez pas à:

      - suivre ce compte sur Nostr pour ne rater aucune nouvelle aventure
      - aller faire un tour sur flownaely.cafe ☕

      https://flownaely.cafe
    BACKCOVER
  end
end
