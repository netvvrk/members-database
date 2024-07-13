class RemoveEmailFromProfiles < ActiveRecord::Migration[7.1]
  def change
    remove_column :profiles, :email
  end
end
