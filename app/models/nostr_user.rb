class NostrUser < ApplicationRecord
  enum language: { french: 0, english: 1 }

  has_one_attached :avatar

  encrypts :public_key, :private_key

  validates :name, presence: true
  # validates :public_key, presence: true
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
#  public_key    :string
#  private_key   :string
#  relay_url     :string
#  language      :integer          default("french"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  stories_count :integer          default(0), not null
#
# Indexes
#
#  index_nostr_users_on_private_key  (private_key) UNIQUE
#  index_nostr_users_on_public_key   (public_key) UNIQUE
#
