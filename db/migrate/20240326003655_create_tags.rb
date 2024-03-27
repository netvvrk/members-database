class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.text :name

      t.timestamps
    end

    ["Abstract", "Representational", "Figurative", "Non-objective",
     "Geometric", "Site-specific", "Immersive", "Environmental",
     "Conceptual", "Social practice", "Portrait", "Landscape"].each { | tag_name | Tag.create!(name: tag_name) }
  end
end
