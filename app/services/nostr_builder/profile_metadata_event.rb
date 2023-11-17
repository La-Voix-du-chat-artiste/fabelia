module NostrBuilder
  class ProfileMetadataEvent < BaseEvent
    include Rails.application.routes.url_helpers

    attr_reader :nostr_user

    def initialize(nostr_user)
      @nostr_user = nostr_user
    end

    def call
      nostr.build_metadata_event(
        name: nostr_user.name,
        display_name: nostr_user.display_name,
        about: nostr_user.about,
        picture: picture,
        banner: banner,
        nip05: nostr_user.nip05,
        lud16: nostr_user.lud16,
        website: nostr_user.website
      )
    end

    private

    def picture
      return unless nostr_user.picture.attached?

      polymorphic_url(nostr_user.picture, port: nil, host: ENV.fetch('HOST', nil))
    end

    def banner
      return unless nostr_user.banner.attached?

      polymorphic_url(nostr_user.banner, port: nil, host: ENV.fetch('HOST', nil))
    end
  end
end
