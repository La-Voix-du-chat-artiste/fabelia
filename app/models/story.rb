class Story < ApplicationRecord
  has_many :chapters, dependent: :destroy

  scope :currents, -> { where(adventure_ended_at: nil) }

  def self.current?
    exists?(adventure_ended_at: nil)
  end

  def ended!
    update(adventure_ended_at: Time.current)
  end
end

# == Schema Information
#
# Table name: stories
#
#  id                 :integer          not null, primary key
#  title              :string
#  chapters_count     :integer          default(0), not null
#  adventure_ended_at :datetime
#  raw_response_body  :json             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
