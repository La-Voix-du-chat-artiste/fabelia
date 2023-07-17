class Chapter < ApplicationRecord
  belongs_to :story, counter_cache: true

  has_one_attached :cover

  scope :published, -> { where.not(published_at: nil) }

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
end

# == Schema Information
#
# Table name: chapters
#
#  id                   :bigint(8)        not null, primary key
#  title                :string
#  content              :text
#  summary              :string
#  published_at         :datetime
#  nostr_identifier     :string
#  replicate_identifier :string
#  raw_response_body    :json             not null
#  story_id             :bigint(8)        not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
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
