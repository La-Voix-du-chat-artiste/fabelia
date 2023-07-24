class CreateNostrUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :nostr_users do |t|
      t.string :name
      t.string :public_key
      t.string :private_key
      t.string :relay_url
      t.integer :language, null: false, default: 0

      t.timestamps
    end

    add_index :nostr_users, :public_key, unique: true
    add_index :nostr_users, :private_key, unique: true
  end
end
