class AddBackCoverNostrIdentifierToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :back_cover_nostr_identifier, :string
    add_index :stories, :back_cover_nostr_identifier, unique: true
  end
end
