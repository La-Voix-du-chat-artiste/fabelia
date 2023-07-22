class NostrEvent < ApplicationService
  private

  def nostr
    @nostr ||= Nostr.new(private_key: private_key)
  end

  def public_key
    ENV.fetch('NOSTR_PUBLIC_KEY', nil)
  end

  def private_key
    ENV.fetch('NOSTR_PRIVATE_KEY', nil)
  end

  def relay_url
    ENV.fetch('NOSTR_RELAY_URL', nil)
  end

  def created_at
    Time.current.utc.to_i
  end
end
