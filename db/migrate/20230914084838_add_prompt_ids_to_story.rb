class AddPromptIdsToStory < ActiveRecord::Migration[7.0]
  def change
    add_reference :stories, :media_prompt, foreign_key: { to_table: :prompts }, type: :uuid
    add_reference :stories, :narrator_prompt, foreign_key: { to_table: :prompts }, type: :uuid
    add_reference :stories, :atmosphere_prompt, foreign_key: { to_table: :prompts }, type: :uuid
  end
end
