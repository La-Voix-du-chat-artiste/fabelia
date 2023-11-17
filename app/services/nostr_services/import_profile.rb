require 'open-uri'

module NostrServices
  class ImportProfile < ApplicationService
    attr_reader :nostr_user

    def initialize(nostr_user)
      @nostr_user = nostr_user
    end

    def call
      nostr_user.metadata_response = metadata

      nostr_user.name = nostr_user.metadata_response.name
      nostr_user.display_name = nostr_user.metadata_response.display_name
      nostr_user.about = nostr_user.metadata_response.about
      nostr_user.nip05 = nostr_user.metadata_response.nip05
      nostr_user.lud16 = nostr_user.metadata_response.lud16
      nostr_user.website = nostr_user.metadata_response.website

      if nostr_user.metadata_response.banner.present?
        begin
          nostr_user.banner = {
            io: URI.parse(nostr_user.metadata_response.banner).open,
            filename: 'user_banner'
          }
        rescue OpenURI::HTTPError
          nil
        end
      end

      if nostr_user.metadata_response.picture.present?
        begin
          nostr_user.picture = {
            io: URI.parse(nostr_user.metadata_response.picture).open,
            filename: 'user_picture'
          }
        rescue OpenURI::HTTPError
          nil
        end
      end

      nostr_user.save!
    end

    private

    def metadata
      @metadata ||= NostrBuilder::ProfileRequestEvent.call(nostr_user)
    end
  end
end
