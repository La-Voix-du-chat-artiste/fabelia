class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.string :title
      t.integer :chapters_count, null: false, default: 0
      t.datetime :adventure_ended_at
      t.json :raw_response_body, null: false, default: {}

      t.timestamps
    end
  end
end
