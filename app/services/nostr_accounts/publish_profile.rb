module NostrAccounts
  class PublishProfile < ApplicationService
    include Rails.application.routes.url_helpers

    attr_reader :nostr_user

    def initialize(nostr_user)
      @nostr_user = nostr_user
    end

    def build_and_publish_event
      picture = nostr_user.picture.attached? ? polymorphic_url(nostr_user.picture, port: nil, host: ENV.fetch('HOST', nil)) : nil
      banner = nostr_user.banner.attached? ? polymorphic_url(nostr_user.banner, port: nil, host: ENV.fetch('HOST', nil)) : nil

      metadata = nostr.build_metadata_event(
        name: nostr_user.name,
        display_name: nostr_user.display_name,
        about: nostr_user.about,
        picture: picture,
        banner: banner,
        nip05: nostr_user.nip05,
        lud16: nostr_user.lud16,
        website: nostr_user.website
      )

      nostr.test_post_event(metadata, Relay.main.url)

      content = JSON.parse(metadata.last[:content])
      nostr_user.update(metadata_response: content)
    end

    private

    def nostr
      @nostr ||= Nostr.new(private_key: nostr_user.private_key)
    end
  end
end
