class RemoveUniqueIndexOnNostrUserLanguage < ActiveRecord::Migration[7.0]
  def up
    remove_index :nostr_users, :language
  end

  def down
    add_index :nostr_users, :language, unique: true
  end
end
