class SplitUserName < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :name
    add_column :users, :first_name, :string, null: false, default: ""
    add_column :users, :last_name, :string, null: false, default: ""
    add_index :users, [:last_name, :first_name]
  end
end
