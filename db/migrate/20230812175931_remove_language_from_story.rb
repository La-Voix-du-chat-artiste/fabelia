class RemoveLanguageFromStory < ActiveRecord::Migration[7.0]
  def change
    remove_column :stories, :language, :integer, null: false, default: 0
  end
end
