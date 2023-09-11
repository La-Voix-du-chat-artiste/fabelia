class AddOptionsToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :options, :jsonb, null: false, default: {}
  end
end
