class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places, id: :uuid do |t|
      t.string :name
      t.text :description
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end
  end
end
