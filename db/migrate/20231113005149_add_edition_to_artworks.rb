class AddEditionToArtworks < ActiveRecord::Migration[7.1]
  def change
    add_column :artworks, :edition, :string, null: false, default: ""
  end
end
