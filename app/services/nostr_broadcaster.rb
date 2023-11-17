class NostrBroadcaster < ApplicationService
  include Mixin::Nostrable

  attr_reader :nostr_user, :event

  def initialize(nostr_user, event)
    @nostr_user = nostr_user
    @event = event
  end

  def call
    validate!

    relay_urls.each do |relay_url|
      nostr.test_post_event(event, relay_url)
    end

    event.last['id']
  end

  private

  def validate!
    raise NostrUserErrors::MissingAssociatedRelay if relay_urls.empty?
  end
end
