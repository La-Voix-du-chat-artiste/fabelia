class Chapter < ApplicationRecord
  belongs_to :story, counter_cache: true

  scope :published, -> { where.not(published_at: nil) }

  def last_published?
    story.chapters.published.count == story.chapters_count &&
      self == last_published
  end

  def last_published
    story.chapters.published.last
  end
end

# == Schema Information
#
# Table name: chapters
#
#  id               :integer          not null, primary key
#  title            :string
#  content          :text
#  published_at     :datetime
#  event_identifier :string
#  story_id         :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_chapters_on_event_identifier  (event_identifier) UNIQUE
#  index_chapters_on_story_id          (story_id)
#
# Foreign Keys
#
#  story_id  (story_id => stories.id)
#
