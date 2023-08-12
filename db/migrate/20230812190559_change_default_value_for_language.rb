class ChangeDefaultValueForLanguage < ActiveRecord::Migration[7.0]
  def change
    change_column_default :nostr_users, :language, from: nil, to: 'EN'
  end
end
