class DecimalsForDimensions < ActiveRecord::Migration[7.2]
  def change
    change_column(:artworks, :height, :decimal)
    change_column(:artworks, :width, :decimal)
    change_column(:artworks, :depth, :decimal)
  end
end
