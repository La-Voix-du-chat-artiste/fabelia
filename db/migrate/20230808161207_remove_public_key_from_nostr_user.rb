class RemovePublicKeyFromNostrUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :nostr_users, :public_key, :string
  end
end
