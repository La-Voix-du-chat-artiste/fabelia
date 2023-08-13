class Thematic < ApplicationRecord
  scope :enabled, -> { where(enabled: true) }

  after_destroy_commit do
    broadcast_remove_to :thematics
  end

  validates :name_fr, presence: true
  validates :name_en, presence: true
  validates :description_fr, presence: true
  validates :description_en, presence: true
  validates :identifier, presence: true, uniqueness: { case_sensitive: false }

  def name
    name_fr
  end

  def description
    description_fr
  end
end

# == Schema Information
#
# Table name: thematics
#
#  id             :bigint(8)        not null, primary key
#  identifier     :string
#  name_fr        :string
#  name_en        :string
#  description_fr :text
#  description_en :text
#  stories_count  :integer          default(0), not null
#  enabled        :boolean          default(TRUE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_thematics_on_identifier  (identifier) UNIQUE
#
