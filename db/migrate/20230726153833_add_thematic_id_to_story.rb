class AddThematicIdToStory < ActiveRecord::Migration[7.0]
  def change
    add_reference :stories, :thematic, foreign_key: true, type: :uuid
  end
end
