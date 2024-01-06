class Chapter < ApplicationRecord
  include Coverable
  include NSFWCoverable

  enum :status, { draft: 0, completed: 1 }, validate: true

  belongs_to :story, counter_cache: true, touch: true

  after_create_commit do
    broadcast_append_to :chapters, target: "chapters_story_#{story.id}"
    generate_cover if completed?
    refresh_previous_chapter if previous?

    broadcast_chapter_details if story.dropper? || (story.complete? && position == 1)
  end

  after_update_commit do
    if status_previously_changed?(from: :draft, to: :completed)
      broadcast_chapter
      generate_cover

      broadcast_chapter_details if story.dropper? || (story.complete? && position == 1)
    elsif published_at_previously_changed?
      broadcast_chapter_details
    end
  end

  scope :published, -> { where.not(published_at: nil) }
  scope :not_published, -> { where(published_at: nil) }
  scope :by_position, -> { order(:position) }

  acts_as_list scope: :story

  def first_to_publish?
    story.chapters.published.blank? && self == story.chapters.first
  end

  def last_to_publish?
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
    broadcast_replace_to :chapters
  end

  def broadcast_chapter_details
    broadcast_update_to :chapters,
                        locals: { chapter: self },
                        target: :panel_details,
                        partial: 'stories/chapters/details'
  end

  def broadcast_cover
    broadcast_replace_to :chapters,
                         target: "cover_chapter_#{id}",
                         partial: 'stories/chapters/cover'
  end

  def broadcast_cover_placeholder
    broadcast_update_to :chapters,
                        target: "cover_chapter_#{id}",
                        partial: 'stories/chapters/cover_placeholder'
  end

  def most_voted_option
    options[most_voted_option_index]
  end

  def previous
    @previous ||= story.chapters.find_by(position: position - 1)
  end

  def next_one
    @next_one ||= story.chapters.find_by(position: position + 1)
  end

  def previous?
    previous.present?
  end

  def next_one?
    next_one.present?
  end

  private

  def generate_cover
    ReplicateServices::Picture.call(self, summary, publish: publish)
  end

  def refresh_previous_chapter
    broadcast_replace_to :chapters,
                         locals: { chapter: previous },
                         target: "chapter_#{previous.id}"
  end
end

# == Schema Information
#
# Table name: chapters
#
#  id                          :uuid             not null, primary key
#  title                       :string
#  content                     :text
#  summary                     :string
#  published_at                :datetime
#  nostr_identifier            :string
#  replicate_identifier        :string
#  replicate_raw_response_body :json             not null
#  story_id                    :uuid             not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  prompt                      :text
#  chat_raw_response_body      :json             not null
#  replicate_raw_request_body  :json             not null
#  position                    :integer          default(1), not null
#  publish                     :boolean          default(FALSE), not null
#  status                      :integer          default("draft"), not null
#  most_voted_option_index     :integer
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
