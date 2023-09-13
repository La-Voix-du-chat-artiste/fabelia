class CreateJoinTableCharactersStories < ActiveRecord::Migration[7.0]
  def change
    create_join_table :characters, :stories do |t|
      t.index %i[character_id story_id], unique: true
    end
  end
end
