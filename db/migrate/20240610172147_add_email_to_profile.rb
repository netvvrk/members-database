class AddEmailToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :email, :string
  end
end
