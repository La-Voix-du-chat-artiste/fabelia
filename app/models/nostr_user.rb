class NostrUser < ApplicationRecord
  enum language: { fr: 0, en: 1 }

  has_one_attached :avatar

  encrypts :private_key

  humanize :language, enum: true

  scope :enabled, -> { where(enabled: true) }

  validates :name, presence: true
  validates :private_key, presence: true
  validates :relay_url, presence: true

  def self.remaining_languages
    languages.keys - distinct.pluck(:language)
  end
end

# == Schema Information
#
# Table name: nostr_users
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  private_key   :string
#  relay_url     :string
#  language      :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  stories_count :integer          default(0), not null
#  enabled       :boolean          default(TRUE), not null
#
# Indexes
#
#  index_nostr_users_on_private_key  (private_key) UNIQUE
#
