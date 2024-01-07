class Company < ApplicationRecord
  with_options dependent: :destroy do
    has_one :setting
    has_many :characters
    has_many :nostr_users
    has_many :places
    has_many :prompts
    has_many :media_prompts, -> { where(type: 'MediaPrompt') }, inverse_of: :company
    has_many :narrator_prompts, -> { where(type: 'NarratorPrompt') }, inverse_of: :company
    has_many :atmosphere_prompts, -> { where(type: 'AtmospherePrompt') }, inverse_of: :company
    has_many :relays
    has_many :stories
    has_many :chapters, through: :stories
    has_many :thematics
    has_many :users
  end

  validates :name, presence: true, uniqueness: true

  has_one_attached :logo
end

# == Schema Information
#
# Table name: companies
#
#  id          :uuid             not null, primary key
#  name        :string
#  users_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_companies_on_name  (name) UNIQUE
#
