class AddMetadataResponseToNostrUser < ActiveRecord::Migration[7.0]
  def change
    add_column :nostr_users, :metadata_response, :json, null: false, default: {}
  end
end
