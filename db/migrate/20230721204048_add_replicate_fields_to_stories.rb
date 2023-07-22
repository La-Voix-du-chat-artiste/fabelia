class AddReplicateFieldsToStories < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :replicate_identifier, :string
    add_column :stories, :replicate_raw_request_body, :json, null: false, default: {}
    add_column :stories, :replicate_raw_response_body, :json, null: false, default: {}

    add_index :stories, :replicate_identifier, unique: true
  end
end
