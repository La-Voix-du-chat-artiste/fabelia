class ChangeLanguageTypeToNostrUsers < ActiveRecord::Migration[7.0]
  def up
    change_column :nostr_users, :language, :string,
                  limit: 2, default: nil
    add_index :nostr_users, :language, unique: true
  end

  def down
    remove_index :nostr_users, :language, unique: true
    change_column :nostr_users, :language, :integer,
                  null: false, default: 0, using: 'language::integer'
  end
end
