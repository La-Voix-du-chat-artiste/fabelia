class Relay < ApplicationRecord
  DEFAULT_LIST = %w[
    wss://no.str.cr
    wss://relay.snort.social
    wss://relay.damus.io
    wss://nostr.bitcoiner.social
    wss://relay.nostr.bg
    wss://nostr.oxtr.dev
    wss://nostr-pub.wellorder.net
    wss://nostr.mom
    wss://nos.lol
  ].freeze

  has_many :nostr_users_relays, dependent: :destroy
  has_many :nostr_users, through: :nostr_users_relays

  acts_as_list

  scope :enabled, -> { where(enabled: true) }
  scope :by_position, -> { order(:position) }

  validates :url, presence: true, uniqueness: { case_sensitive: false }

  after_validation :clean_url
  after_update :delete_nostr_users_association, if: :marked_as_disabled?

  def self.main
    enabled.by_position.first
  end

  def self.reset!
    transaction do
      Relay.delete_all

      DEFAULT_LIST.each do |relay|
        create!(url: relay)
      end
    end
  end

  # NOTE: title is used as alias to get correct form label association
  def title
    url
  end

  private

  def clean_url
    return if url.blank?

    cleaned_url = url.strip
                     .delete_prefix('http://')
                     .delete_prefix('https://')

    cleaned_url = "wss://#{cleaned_url}" unless cleaned_url.starts_with?('ws://') || cleaned_url.starts_with?('wss://')

    self.url = cleaned_url
  end

  def delete_nostr_users_association
    nostr_users_relays.delete_all
  end

  def marked_as_disabled?
    enabled_previously_changed?(from: true, to: false)
  end
end

# == Schema Information
#
# Table name: relays
#
#  id          :bigint(8)        not null, primary key
#  url         :string
#  description :text
#  enabled     :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer          default(1), not null
#
# Indexes
#
#  index_relays_on_url  (url) UNIQUE
#
