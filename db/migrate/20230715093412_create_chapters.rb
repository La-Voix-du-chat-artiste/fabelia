class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters, id: :uuid do |t|
      t.string :title
      t.text :content
      t.string :summary
      t.datetime :published_at
      t.string :nostr_identifier, index: { unique: true }
      t.string :replicate_identifier, index: { unique: true }
      t.json :raw_response_body, null: false, default: {}
      t.references :story, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
