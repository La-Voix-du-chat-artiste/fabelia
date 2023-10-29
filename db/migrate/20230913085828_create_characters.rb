class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.text :biography
      t.boolean :enabled, null: false, default: true
      t.references :company, null: false, foreign_key: true, type: :uuid

      t.timestamps

      t.index %i[first_name last_name], unique: true
    end
  end
end
