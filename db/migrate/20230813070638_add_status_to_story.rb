class AddStatusToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :status, :integer, null: false, default: 0
  end
end
