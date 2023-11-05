class CreateArtworks < ActiveRecord::Migration[7.0]
  def change
    create_table :artworks do |t|
      t.string :title, null: false
      t.string :medium, null: false
      t.string :description
      t.integer :price
      t.boolean :visible
      t.integer :duration
      t.string :units, null: false, default: "in"
      t.float :height
      t.float :width
      t.float :depth
      t.string :location, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
