class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.jsonb :chapter_options, null: false, default: {}
      t.references :company, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
