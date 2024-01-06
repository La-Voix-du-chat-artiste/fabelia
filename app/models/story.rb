class Story < ApplicationRecord
  include Coverable
  include NSFWCoverable

  enum :mode, { complete: 0, dropper: 1 }, default: :complete, validate: true
  enum :status, { draft: 0, completed: 1 }, default: :draft, validate: true
  enum :publication_rule, {
    do_not_publish: 0,
    publish_first_chapter: 1,
    publish_all_chapters: 2
  }, default: :do_not_publish, validate: true

  attribute :options, StoryOption.to_type

  attr_accessor :light_form

  belongs_to :thematic, counter_cache: true
  belongs_to :nostr_user, counter_cache: true

  with_options inverse_of: :stories do
    belongs_to :media_prompt, -> { where(type: 'MediaPrompt') }, counter_cache: true
    belongs_to :narrator_prompt, -> { where(type: 'NarratorPrompt') }, counter_cache: true
    belongs_to :atmosphere_prompt, -> { where(type: 'AtmospherePrompt') }, counter_cache: true
  end

  has_many :chapters, dependent: :destroy
  has_many :characters_stories, dependent: :delete_all
  has_many :characters, through: :characters_stories
  has_many :places_stories, dependent: :delete_all
  has_many :places, through: :places_stories

  humanize :mode, enum: true
  humanize :publication_rule, enum: true

  before_validation :assign_random_thematic, if: -> { thematic.blank? }
  before_validation :assign_media_prompt, if: :light_form?
  before_validation :assign_narrator_prompt, if: :light_form?
  before_validation :assign_atmosphere_prompt, if: :light_form?

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
  validates :publication_rule, presence: true, inclusion: { in: publication_rules.keys }
  validates :options, store_model: { merge_errors: true }

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

  def broadcast_cover_placeholder
    broadcast_update_to :stories,
                        target: "cover_story_#{id}",
                        partial: 'stories/cover_placeholder'
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

  def front_cover_published?
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

  def publish_me?(index = nil)
    return publish_first_chapter? if dropper?

    publish_all_chapters? || (publish_first_chapter? && index.zero?)
  end

  def disabled?
    !enabled?
  end

  def light_form?
    light_form.to_bool
  end

  private

  def assign_random_thematic
    self.thematic = Thematic.enabled.sample
  end

  def assign_media_prompt
    self.media_prompt = MediaPrompt.enabled.first
  end

  def assign_narrator_prompt
    self.narrator_prompt = NarratorPrompt.enabled.first
  end

  def assign_atmosphere_prompt
    self.atmosphere_prompt = AtmospherePrompt.enabled.first
  end

  def generate_cover
    ReplicateServices::Picture.call(self, summary)
  end
end

# == Schema Information
#
# Table name: stories
#
#  id                          :uuid             not null, primary key
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
#  thematic_id                 :uuid
#  enabled                     :boolean          default(TRUE), not null
#  nostr_identifier            :string
#  nostr_user_id               :uuid
#  summary                     :string
#  back_cover_nostr_identifier :string
#  publication_rule            :integer          default("do_not_publish"), not null
#  status                      :integer          default("draft"), not null
#  options                     :jsonb            not null
#  media_prompt_id             :uuid
#  narrator_prompt_id          :uuid
#  atmosphere_prompt_id        :uuid
#
# Indexes
#
#  index_stories_on_atmosphere_prompt_id         (atmosphere_prompt_id)
#  index_stories_on_back_cover_nostr_identifier  (back_cover_nostr_identifier) UNIQUE
#  index_stories_on_media_prompt_id              (media_prompt_id)
#  index_stories_on_narrator_prompt_id           (narrator_prompt_id)
#  index_stories_on_nostr_identifier             (nostr_identifier) UNIQUE
#  index_stories_on_nostr_user_id                (nostr_user_id)
#  index_stories_on_replicate_identifier         (replicate_identifier) UNIQUE
#  index_stories_on_thematic_id                  (thematic_id)
#
# Foreign Keys
#
#  fk_rails_...  (atmosphere_prompt_id => prompts.id)
#  fk_rails_...  (media_prompt_id => prompts.id)
#  fk_rails_...  (narrator_prompt_id => prompts.id)
#  fk_rails_...  (nostr_user_id => nostr_users.id)
#  fk_rails_...  (thematic_id => thematics.id)
#
