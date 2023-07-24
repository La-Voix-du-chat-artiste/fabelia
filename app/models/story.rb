class Story < ApplicationRecord
  THEMATICS = ['médiévale', 'spatiale', 'maritime', 'en ville', 'dans la jungle', 'en bord de mer', "sous l'eau"].freeze

  enum mode: { complete: 0, dropper: 1 }
  enum language: { french: 0, english: 1 }

  humanize :mode, enum: true
  humanize :language, enum: true

  has_many :chapters, dependent: :destroy

  has_one_attached :cover

  scope :currents, -> { where(adventure_ended_at: nil) }
  scope :ended, -> { where.not(adventure_ended_at: nil) }

  def self.current?
    exists?(adventure_ended_at: nil)
  end

  def current?
    adventure_ended_at.nil? && chapters.published.any?
  end

  def ended?
    adventure_ended_at.present?
  end

  def ended!
    update(adventure_ended_at: Time.current)
  end

  def replicate_cover
    replicate_raw_response_body['data']['output'].first
  rescue StandardError
    nil
  end
end

# == Schema Information
#
# Table name: stories
#
#  id                          :bigint(8)        not null, primary key
#  title                       :string
#  chapters_count              :integer          default(0), not null
#  adventure_ended_at          :datetime
#  raw_response_body           :json             not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  mode                        :integer          default("complete"), not null
#  replicate_identifier        :string
#  replicate_raw_request_body  :json             not null
#  replicate_raw_response_body :json             not null
#  language                    :integer          default("french"), not null
#
# Indexes
#
#  index_stories_on_replicate_identifier  (replicate_identifier) UNIQUE
#
