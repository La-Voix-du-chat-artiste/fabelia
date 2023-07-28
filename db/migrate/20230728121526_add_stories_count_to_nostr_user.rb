class AddStoriesCountToNostrUser < ActiveRecord::Migration[7.0]
  def change
    add_column :nostr_users, :stories_count, :integer, null: false, default: 0
  end
end
