class AddYearToArtworks < ActiveRecord::Migration[7.1]
  def change
    add_column :artworks, :year, :integer, null: false
    add_index :artworks, :year
  end
end
