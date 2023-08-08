class AddEnabledToNostrUser < ActiveRecord::Migration[7.0]
  def change
    add_column :nostr_users, :enabled, :boolean, null: false, default: true
  end
end
