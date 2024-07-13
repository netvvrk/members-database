class AddNameToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :name, :string, null: false, default: ""
    add_index :profiles, :name
  end
end
