class AddDisplayNameToNostrUser < ActiveRecord::Migration[7.0]
  def change
    add_column :nostr_users, :display_name, :string
  end
end
