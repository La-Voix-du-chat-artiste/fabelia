class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.string :first_name
      t.string :last_name
      t.text :biography
      t.boolean :enabled, null: false, default: true

      t.timestamps

      t.index %i[first_name last_name], unique: true
    end
  end
end
