class Place < ApplicationRecord
  include ActionView::Helpers::AssetTagHelper
  include Rails.application.routes.url_helpers

  has_many :places_stories, dependent: :delete_all
  has_many :places, through: :places_stories

  has_one_attached :photo

  scope :enabled, -> { where(enabled: true) }

  validates :name, presence: true
  validates :description, presence: true

  def photo_url
    return 'placeholder_nostr_picture.png' unless photo.attached?

    polymorphic_path(photo, only_path: true)
  end
end

# == Schema Information
#
# Table name: places
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  description :text
#  enabled     :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
