class AddNostrIdentifierToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :nostr_identifier, :string
    add_index :stories, :nostr_identifier, unique: true
  end
end
