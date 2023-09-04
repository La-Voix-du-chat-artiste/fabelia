class NostrUser < ApplicationRecord
  enum mode: { generated: 0, imported: 1 }, _default: :generated

  has_many :nostr_users_relays, dependent: :delete_all
  has_many :relays, -> { by_position }, through: :nostr_users_relays
  has_many :stories, dependent: :destroy

  validates :name, presence: true, if: :generated?
  validates :private_key, presence: true
  validates :relays, presence: true
  validates :language, presence: true
  validates :nip05, allow_blank: true, format: { with: User::EMAIL_REGEX }
  validates :lud16, allow_blank: true, format: { with: User::EMAIL_REGEX }

  attribute :metadata_response, NostrProfile.to_type

  has_one_attached :picture
  has_one_attached :banner

  encrypts :private_key

  before_validation :generate_private_key, on: :create, if: :generated?

  after_destroy_commit do
    broadcast_remove_to :nostr_users
  end

  scope :enabled, -> { where(enabled: true) }
  scope :by_language, ->(language) { where(language: language) }

  alias_attribute :profile, :metadata_response

  def public_key
    Nostr.new(private_key: private_key).bech32_keys[:public_key]
  end

  def human_language
    I18nData.languages(I18n.locale)[language.upcase].capitalize
  rescue StandardError
    'Unknown language'
  end

  def initials
    return if name.blank?

    first, last = name.split

    return first[0].upcase if last.blank?

    "#{first[0]}#{last[0]}".upcase
  end

  private

  def generate_private_key
    self.private_key = SecureRandom.hex(32)
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
#  mode              :integer          default("generated"), not null
#  name              :string
#  about             :text
#  nip05             :string
#  website           :string
#  lud16             :string
#
# Indexes
#
#  index_nostr_users_on_private_key  (private_key) UNIQUE
#
