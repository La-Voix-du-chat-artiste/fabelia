class Prompt < ApplicationRecord
  include Archivable

  validates :title, presence: true
  validates :body, presence: true

  scope :enabled, -> { where(enabled: true) }
  scope :by_position, -> { order(:position) }

  acts_as_list scope: [:type]
end

# == Schema Information
#
# Table name: prompts
#
#  id            :uuid             not null, primary key
#  type          :string
#  title         :string
#  body          :text
#  negative_body :text
#  options       :jsonb            not null
#  stories_count :integer          default(0), not null
#  enabled       :boolean          default(TRUE), not null
#  position      :integer          default(1), not null
#  archived_at   :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
