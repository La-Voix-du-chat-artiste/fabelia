class Character < ApplicationRecord
  include ActionView::Helpers::AssetTagHelper
  include Rails.application.routes.url_helpers

  has_many :characters_stories, dependent: :delete_all
  has_many :stories, through: :characters_stories

  has_one_attached :avatar

  scope :enabled, -> { where(enabled: true) }

  validates :first_name, presence: true
  validates :last_name, uniqueness: { scope: :first_name }
  validates :biography, presence: true

  def full_name
    "#{first_name} #{last_name}".strip
  end

  # NOTE: name is used as alias to get correct form label association
  def name
    full_name
  end

  def avatar_url
    return 'placeholder_nostr_picture.png' unless avatar.attached?

    polymorphic_path(avatar, only_path: true)
  end
end

# == Schema Information
#
# Table name: characters
#
#  id         :bigint(8)        not null, primary key
#  first_name :string
#  last_name  :string
#  biography  :text
#  enabled    :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_characters_on_first_name_and_last_name  (first_name,last_name) UNIQUE
#
