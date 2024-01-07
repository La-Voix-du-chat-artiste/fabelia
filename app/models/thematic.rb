class Thematic < ApplicationRecord
  belongs_to :company
  has_many :stories, dependent: :nullify

  scope :enabled, -> { where(enabled: true) }

  after_destroy_commit do
    broadcast_remove_to :thematics
  end

  validates :name_fr, presence: true
  validates :name_en, presence: true
  validates :description_fr, presence: true
  validates :description_en, presence: true

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
#  id             :uuid             not null, primary key
#  name_fr        :string
#  name_en        :string
#  description_fr :text
#  description_en :text
#  stories_count  :integer          default(0), not null
#  enabled        :boolean          default(TRUE), not null
#  company_id     :uuid             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_thematics_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
