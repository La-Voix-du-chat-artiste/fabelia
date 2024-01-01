class CreateJoinTablePlacesStories < ActiveRecord::Migration[7.0]
  def change
    create_join_table :places, :stories, column_options: { type: :uuid } do |t|
      t.index :place_id
      t.index :story_id
    end
  end
end
