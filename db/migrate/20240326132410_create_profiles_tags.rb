class CreateProfilesTags < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles_tags, id: false do |t|
      t.integer :profile_id
      t.integer :tag_id
      t.timestamps
    end
    add_index :profiles_tags, :profile_id
    add_index :profiles_tags, :tag_id
  end
end
