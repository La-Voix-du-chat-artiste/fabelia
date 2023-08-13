class AddPublicationRuleToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :publication_rule, :integer, null: false, default: 0
  end
end
