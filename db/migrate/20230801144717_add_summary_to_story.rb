class AddSummaryToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :summary, :string
  end
end
