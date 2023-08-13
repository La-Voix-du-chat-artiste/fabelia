class Story < ApplicationRecord
  include Coverable
  include NSFWCoverable

  enum mode: { complete: 0, dropper: 1 }
  enum status: { draft: 0, completed: 1 }

  belongs_to :thematic, counter_cache: true
  belongs_to :nostr_user, counter_cache: true

  humanize :mode, enum: true

  has_many :chapters, dependent: :destroy

  before_validation :assign_random_thematic, if: -> { thematic.blank? }

  after_create_commit do
    broadcast_prepend_to :stories

    hide_empty_stories if Story.current?
  end

  after_update_commit do
    if status_previously_changed?(from: :draft, to: :completed)
      broadcast_replace_to :stories
      generate_cover
    end
  end

  after_destroy_commit do
    broadcast_remove_to :stories

    display_empty_stories unless Story.current?
  end

  validates :mode, presence: true, inclusion: { in: modes.keys }

  scope :currents, -> { where(adventure_ended_at: nil) }
  scope :ended, -> { where.not(adventure_ended_at: nil) }
  scope :enabled, -> { where(enabled: true) }

  def self.display_placeholder
    Turbo::StreamsChannel.broadcast_update_to(
      %i[stories current],
      target: 'placeholder_story',
      partial: 'stories/placeholder'
    )
  end

  def self.hide_placeholder
    Turbo::StreamsChannel.broadcast_update_to(
      %i[stories current],
      target: 'placeholder_story',
      html: ''
    )
  end

  def self.publishable(language: nil)
    scope = complete.currents.enabled
                    .joins(:chapters)
                    .merge(Chapter.not_published)

    if language.present?
      scope = scope.joins(:nostr_user)
                   .merge(NostrUser.by_language(language))
    end

    scope
  end

  def self.current?
    exists?(adventure_ended_at: nil)
  end

  delegate :human_language, to: :nostr_user

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
    stories = {}
    NostrUser.pluck(:language).each do |language|
      stories[language] = Story.publishable(language: language).first
    end

    broadcast_replace_to :active_stories,
                         partial: 'homes/stories',
                         target: 'quick_look',
                         locals: {
                           stories: stories
                         }
  end

  def broadcast_move_from_current_to_ended
    broadcast_remove_to %i[stories current]
    broadcast_prepend_to %i[stories ended]
  end

  def display_empty_stories
    broadcast_replace_to %i[stories current],
                         target: 'empty_stories',
                         partial: 'homes/empty_stories'
  end

  def hide_empty_stories
    broadcast_replace_to %i[stories current],
                         target: 'empty_stories',
                         html: ''
  end

  def publishable_story?
    Story.publishable(language: nostr_user.language).first == self
  end

  def front_cover_pubished?
    nostr_identifier.present?
  end

  def back_cover_published?
    back_cover_nostr_identifier.present?
  end

  def language
    nostr_user.language.downcase
  end

  def thematic_name
    language == 'fr' ? thematic.name_fr : thematic.name_en
  end

  def thematic_description
    language == 'fr' ? thematic.description_fr : thematic.description_en
  end

  private

  def assign_random_thematic
    self.thematic = Thematic.enabled.sample
  end

  def generate_cover
    ReplicateServices::Picture.call(self, summary)
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
#  thematic_id                 :bigint(8)
#  enabled                     :boolean          default(TRUE), not null
#  nostr_identifier            :string
#  nostr_user_id               :bigint(8)
#  summary                     :string
#  back_cover_nostr_identifier :string
#  status                      :integer          default("draft"), not null
#
# Indexes
#
#  index_stories_on_back_cover_nostr_identifier  (back_cover_nostr_identifier) UNIQUE
#  index_stories_on_nostr_identifier             (nostr_identifier) UNIQUE
#  index_stories_on_nostr_user_id                (nostr_user_id)
#  index_stories_on_replicate_identifier         (replicate_identifier) UNIQUE
#  index_stories_on_thematic_id                  (thematic_id)
#
# Foreign Keys
#
#  fk_rails_...  (nostr_user_id => nostr_users.id)
#  fk_rails_...  (thematic_id => thematics.id)
#
