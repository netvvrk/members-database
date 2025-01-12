class AddPositionToArtwork < ActiveRecord::Migration[7.2]
  def change
    add_column :artworks, :position, :integer
    Artwork.heal_position_column! created_at: :asc
    change_column_null :artworks, :position, false
    add_index :artworks, [:user_id, :position], unique: true
  end
end
