class CreatePrompts < ActiveRecord::Migration[7.0]
  def change
    create_table :prompts, id: :uuid do |t|
      t.string :type
      t.string :title
      t.text :body
      t.text :negative_body
      t.jsonb :options, null: false, default: {}
      t.integer :stories_count, null: false, default: 0
      t.boolean :enabled, null: false, default: true
      t.integer :position, null: false, default: 1
      t.datetime :archived_at

      t.timestamps
    end
  end
end
