class NostrEvent < ApplicationService
  private

  def nostr
    @nostr ||= Nostr.new(private_key: private_key)
  end

  def public_key
    nostr.keys[:public_key]
  end

  def private_key
    nostr_user.private_key
  end

  def relay_url
    nostr_user.relay_url
  end

  def created_at
    Time.current.utc.to_i
  end

  def nostr_user
    raise StandardError, 'NostrUser must be defined in subclasses'
  end
end
