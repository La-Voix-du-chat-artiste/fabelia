class Chapter < ApplicationRecord
  belongs_to :story, counter_cache: true, touch: true

  has_one_attached :cover

  scope :published, -> { where.not(published_at: nil) }
  scope :not_published, -> { where(published_at: nil) }
  scope :by_position, -> { order(:position) }

  acts_as_list scope: :story

  def first_to_publish?
    story.chapters.published.blank? && self == story.chapters.first
  end

  def last_published?
    story.chapters.published.count == story.chapters_count &&
      self == last_published
  end

  def last_published
    story.chapters.published.last
  end

  def published?
    !published_at.nil?
  end

  def options
    chat_raw_response_body['options'] || []
  end

  def adventure_ended?
    chat_raw_response_body['adventure_ended'].to_bool
  end

  def broadcast_chapter
    broadcast_replace_to :chapters,
                         locals: { chapter_counter: story.chapters.count }
  end

  def replicate_cover
    replicate_raw_response_body['data']['output'].first
  rescue StandardError
    nil
  end

  # Simulate the most voted option waiting to implement
  # poll zaps with Lightning Network
  def most_voted_option
    options.sample
  end
end

# == Schema Information
#
# Table name: chapters
#
#  id                          :bigint(8)        not null, primary key
#  title                       :string
#  content                     :text
#  summary                     :string
#  published_at                :datetime
#  nostr_identifier            :string
#  replicate_identifier        :string
#  replicate_raw_response_body :json             not null
#  story_id                    :bigint(8)        not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  prompt                      :text
#  chat_raw_response_body      :json             not null
#  replicate_raw_request_body  :json             not null
#  position                    :integer          default(1), not null
#
# Indexes
#
#  index_chapters_on_nostr_identifier      (nostr_identifier) UNIQUE
#  index_chapters_on_replicate_identifier  (replicate_identifier) UNIQUE
#  index_chapters_on_story_id              (story_id)
#
# Foreign Keys
#
#  fk_rails_...  (story_id => stories.id)
#
