class PlacesStory < ApplicationRecord
  belongs_to :place
  belongs_to :story
end

# == Schema Information
#
# Table name: places_stories
#
#  place_id :bigint(8)        not null
#  story_id :bigint(8)        not null
#
# Indexes
#
#  index_places_stories_on_place_id  (place_id)
#  index_places_stories_on_story_id  (story_id)
#
