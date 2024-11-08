class AddPositionToImages < ActiveRecord::Migration[7.2]
  def change
    add_column :images, :position, :integer
    Image.heal_position_column! created_at: :asc
    change_column_null :images, :position, false
    add_index :images, [:artwork_id, :position], unique: true
  end
end
