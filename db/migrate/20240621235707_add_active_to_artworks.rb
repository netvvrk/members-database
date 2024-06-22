class AddActiveToArtworks < ActiveRecord::Migration[7.1]
  def change
    add_column :artworks, :active, :boolean, null: false, default: true
    add_index :artworks, :active
  end
end
