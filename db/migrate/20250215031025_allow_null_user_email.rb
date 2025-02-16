class AllowNullUserEmail < ActiveRecord::Migration[7.2]
  def change
    change_column_null :chargebee_events, :user_email, true
  end
end
