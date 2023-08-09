class RemoveUselessNostrUsersColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :nostr_users, :name, :string
    remove_column :nostr_users, :relay_url, :string
  end
end
