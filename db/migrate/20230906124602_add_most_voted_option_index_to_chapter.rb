class AddMostVotedOptionIndexToChapter < ActiveRecord::Migration[7.0]
  def change
    add_column :chapters, :most_voted_option_index, :integer
  end
end
