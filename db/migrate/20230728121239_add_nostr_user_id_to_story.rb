class AddNostrUserIdToStory < ActiveRecord::Migration[7.0]
  def change
    add_reference :stories, :nostr_user, foreign_key: true, type: :uuid
  end
end
