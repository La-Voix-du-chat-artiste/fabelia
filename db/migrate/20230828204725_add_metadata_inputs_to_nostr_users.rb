class AddMetadataInputsToNostrUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :nostr_users, :mode, :integer, null: false, default: 0
    add_column :nostr_users, :name, :string
    add_column :nostr_users, :about, :text
    add_column :nostr_users, :nip05, :string
    add_column :nostr_users, :website, :string
    add_column :nostr_users, :lud16, :string
  end
end
