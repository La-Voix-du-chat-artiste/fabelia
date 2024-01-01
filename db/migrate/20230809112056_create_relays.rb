class CreateRelays < ActiveRecord::Migration[7.0]
  def change
    create_table :relays, id: :uuid do |t|
      t.string :url, index: { unique: true }
      t.text :description
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end
  end
end
