class Story < ApplicationRecord
  include NSFWCoverable

  enum mode: { complete: 0, dropper: 1 }
  enum language: { french: 0, english: 1 }

  belongs_to :thematic, counter_cache: true
  belongs_to :nostr_user, counter_cache: true

  humanize :mode, enum: true
  humanize :language, enum: true

  has_many :chapters, dependent: :destroy

  has_one_attached :cover

  after_create_commit do
    broadcast_prepend_to :stories
  end

  scope :currents, -> { where(adventure_ended_at: nil) }
  scope :ended, -> { where.not(adventure_ended_at: nil) }
  scope :enabled, -> { where(enabled: true) }

  def self.publishable(language: nil)
    scope = complete.currents.enabled
                    .joins(:chapters)
                    .merge(Chapter.not_published)

    scope = scope.where(language: language) if language.present?
    scope
  end

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

  def broadcast_cover
    broadcast_replace_to :stories,
                         target: "cover_story_#{id}",
                         partial: 'stories/cover'
  end

  def broadcast_next_quick_look_story
    broadcast_replace_to :active_stories,
                         partial: 'homes/stories',
                         target: 'quick_look',
                         locals: {
                           stories: {
                             french: Story.publishable.french.first,
                             english: Story.publishable.english.first
                           }
                         }
  end

  def replicate_cover
    replicate_raw_response_body['data']['output'].first
  rescue StandardError
    nil
  end

  def thematic_name
    french? ? thematic.name_fr.to_s : thematic.name_en.to_s
  end

  def thematic_description
    french? ? thematic.description_fr.to_s : thematic.description_en.to_s
  end

  def summary
    "detailed book illustration, #{title}, #{thematic_description}"
  end

  def publishable_story?
    Story.publishable(language: language).first == self
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
#  thematic_id                 :bigint(8)
#  enabled                     :boolean          default(TRUE), not null
#  nostr_identifier            :string
#
# Indexes
#
#  index_stories_on_nostr_identifier      (nostr_identifier) UNIQUE
#  index_stories_on_replicate_identifier  (replicate_identifier) UNIQUE
#  index_stories_on_thematic_id           (thematic_id)
#
# Foreign Keys
#
#  fk_rails_...  (thematic_id => thematics.id)
#
