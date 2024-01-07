class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :name, index: { unique: true }
      t.integer :users_count

      t.timestamps
    end
  end
end
