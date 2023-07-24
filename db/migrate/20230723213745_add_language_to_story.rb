class AddLanguageToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :language, :integer, null: false, default: 0
  end
end
