class AddPublishToChapter < ActiveRecord::Migration[7.0]
  def change
    add_column :chapters, :publish, :boolean, null: false, default: false
  end
end
