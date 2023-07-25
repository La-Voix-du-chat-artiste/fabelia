class AddPositionToChapter < ActiveRecord::Migration[7.0]
  def change
    add_column :chapters, :position, :integer, null: false, default: 1
  end
end
