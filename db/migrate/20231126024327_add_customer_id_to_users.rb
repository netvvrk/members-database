class AddCustomerIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :cb_customer_id, :string
    add_index :users, :cb_customer_id
  end
end
