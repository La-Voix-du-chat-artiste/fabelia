class AddPositionToRelays < ActiveRecord::Migration[7.0]
  def change
    add_column :relays, :position, :integer, null: false, default: 1
  end
end
