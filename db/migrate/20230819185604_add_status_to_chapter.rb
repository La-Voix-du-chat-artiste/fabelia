class AddStatusToChapter < ActiveRecord::Migration[7.0]
  def change
    add_column :chapters, :status, :integer, null: false, default: 0
  end
end
