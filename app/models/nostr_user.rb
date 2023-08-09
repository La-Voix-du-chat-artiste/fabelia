class NostrUser < ApplicationRecord
  enum language: { fr: 0, en: 1 }

  has_many :nostr_users_relays, dependent: :nullify
  has_many :relays, through: :nostr_users_relays

  validates :private_key, presence: true
  validates :relays, presence: true

  before_save :fetch_metadata, if: :private_key_changed?

  encrypts :private_key

  humanize :language, enum: true

  scope :enabled, -> { where(enabled: true) }

  def public_key
    Nostr.new(private_key: private_key).keys[:public_key]
  end

  # TODO: Extract metadata logic to a dedicated class
  def content
    @content ||= JSON.parse(metadata_response.last['content'])
  rescue StandardError
    {}
  end

  def name
    content['display_name'].presence || content['name'].presence || 'John Doe'
  end

  def picture
    content['picture']
  end

  def banner
    content['banner']
  end

  private

  def fetch_metadata
    self.metadata_response = NostrServices::FetchProfile.call(self)
  end
end

# == Schema Information
#
# Table name: nostr_users
#
#  id                :bigint(8)        not null, primary key
#  private_key       :string
#  language          :integer          default("fr"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stories_count     :integer          default(0), not null
#  enabled           :boolean          default(TRUE), not null
#  metadata_response :json             not null
#
# Indexes
#
#  index_nostr_users_on_private_key  (private_key) UNIQUE
#
