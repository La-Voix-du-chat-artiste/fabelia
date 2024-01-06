class NostrUser < ApplicationRecord
  # include ActionView::Helpers::AssetTagHelper
  include Rails.application.routes.url_helpers

  enum :mode, { generated: 0, imported: 1 }, default: :generated, validate: true

  has_many :nostr_users_relays, dependent: :delete_all
  has_many :relays, -> { by_position }, through: :nostr_users_relays
  has_many :stories, dependent: :destroy

  validates :name, presence: true, if: :generated?
  validates :display_name, presence: true, if: :generated?
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
  before_validation :assign_name, if: -> { name.blank? && display_name.present? }
  before_validation :strip_name, if: -> { name.present? }

  after_destroy_commit do
    broadcast_remove_to :nostr_users
  end

  scope :enabled, -> { where(enabled: true) }
  scope :with_relays, -> { where.associated(:relays) }
  scope :by_language, ->(language) { where(language: language) }

  alias_attribute :profile, :metadata_response

  def public_key
    Nostr.new(private_key: private_key).bech32_keys[:public_key]
  end

  def reduced_public_key
    "#{public_key.first(10)}:#{public_key.last(10)}"
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

  def banner_url
    return 'placeholder_nostr_banner.png' unless banner.attached?

    polymorphic_path(banner, only_path: true)
  end

  def picture_url
    return 'placeholder_nostr_picture.png' unless picture.attached?

    polymorphic_path(picture, only_path: true)
  end

  private

  def generate_private_key
    self.private_key ||= SecureRandom.hex(32)
  end

  def assign_name
    self.name = display_name.parameterize(separator: '_')
  end

  def strip_name
    self.name = name.delete('@')
  end
end

# == Schema Information
#
# Table name: nostr_users
#
#  id                :uuid             not null, primary key
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
#  display_name      :string
#
# Indexes
#
#  index_nostr_users_on_private_key  (private_key) UNIQUE
#
