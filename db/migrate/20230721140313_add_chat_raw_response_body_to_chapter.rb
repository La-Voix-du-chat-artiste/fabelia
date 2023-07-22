class AddChatRawResponseBodyToChapter < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :mode, :integer, null: false, default: 0
    add_column :chapters, :prompt, :text
    add_column :chapters, :chat_raw_response_body, :json, null: false, default: {}
    add_column :chapters, :replicate_raw_request_body, :json, null: false, default: {}
    rename_column :chapters, :raw_response_body, :replicate_raw_response_body
  end
end
