class CharactersStory < ApplicationRecord
  belongs_to :character
  belongs_to :story
end

# == Schema Information
#
# Table name: characters_stories
#
#  character_id :bigint(8)        not null
#  story_id     :bigint(8)        not null
#
# Indexes
#
#  index_characters_stories_on_character_id_and_story_id  (character_id,story_id) UNIQUE
#
