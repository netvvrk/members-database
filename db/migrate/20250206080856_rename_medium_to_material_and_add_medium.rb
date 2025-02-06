class RenameMediumToMaterialAndAddMedium < ActiveRecord::Migration[7.2]
  def change
    rename_column :artworks, :medium, :material
    add_column :artworks, :medium, :string   
  end
end
