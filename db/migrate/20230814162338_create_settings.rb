class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.jsonb :chapter_options, null: false, default: {}

      t.timestamps
    end
  end
end
