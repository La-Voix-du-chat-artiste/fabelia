class CreateNostrUsersRelays < ActiveRecord::Migration[7.0]
  def change
    create_join_table :nostr_users, :relays, column_options: { type: :uuid } do |t|
      t.index %i[nostr_user_id relay_id], unique: true
    end
  end
end
