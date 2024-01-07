class CreateRelays < ActiveRecord::Migration[7.0]
  def change
    create_table :relays, id: :uuid do |t|
      t.string :url
      t.text :description
      t.boolean :enabled, null: false, default: true
      t.references :company, null: false, foreign_key: true, type: :uuid

      t.timestamps

      t.index %i[company_id url], unique: true
    end
  end
end
