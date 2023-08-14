class NostrUser < ApplicationRecord
  has_many :nostr_users_relays, dependent: :delete_all
  has_many :relays, -> { by_position }, through: :nostr_users_relays

  validates :private_key, presence: true
  validates :relays, presence: true
  validates :language, presence: true, uniqueness: { case_sensitive: false }

  attribute :metadata_response, NostrProfile.to_type

  # TODO: Extract this callback from model to controller
  before_save :fetch_metadata, if: :private_key_changed?

  encrypts :private_key

  after_destroy_commit do
    broadcast_remove_to :nostr_users
  end

  scope :enabled, -> { where(enabled: true) }
  scope :by_language, ->(language) { where(language: language) }

  alias_attribute :profile, :metadata_response

  def public_key
    Nostr.new(private_key: private_key).keys[:public_key]
  end

  def human_language
    I18nData.languages(I18n.locale)[language].capitalize
  rescue StandardError
    'Unknown language'
  end

  private

  def fetch_metadata
    self.metadata_response = NostrServices::FetchProfile.call(self)
  rescue StandardError
    nil
  end
end

# == Schema Information
#
# Table name: nostr_users
#
#  id                :bigint(8)        not null, primary key
#  private_key       :string
#  language          :string(2)        default("EN"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stories_count     :integer          default(0), not null
#  enabled           :boolean          default(TRUE), not null
#  metadata_response :json             not null
#
# Indexes
#
#  index_nostr_users_on_language     (language) UNIQUE
#  index_nostr_users_on_private_key  (private_key) UNIQUE
#
