class CreateThematics < ActiveRecord::Migration[7.0]
  def change
    create_table :thematics, id: :uuid do |t|
      t.string :name_fr
      t.string :name_en
      t.text :description_fr
      t.text :description_en
      t.integer :stories_count, null: false, default: 0
      t.boolean :enabled, null: false, default: true
      t.references :company, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
