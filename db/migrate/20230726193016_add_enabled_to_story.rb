class AddEnabledToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :enabled, :boolean, null: false, default: true
  end
end
