class AddCompanyReferencesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :company, type: :uuid
  end
end
