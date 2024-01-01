class CharactersStory < ApplicationRecord
  belongs_to :character
  belongs_to :story
end

# == Schema Information
#
# Table name: characters_stories
#
#  character_id :uuid             not null
#  story_id     :uuid             not null
#
# Indexes
#
#  index_characters_stories_on_character_id               (character_id)
#  index_characters_stories_on_character_id_and_story_id  (character_id,story_id) UNIQUE
#  index_characters_stories_on_story_id                   (story_id)
#
