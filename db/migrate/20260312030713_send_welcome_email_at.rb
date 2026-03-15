class SendWelcomeEmailAt < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :send_welcome_email_at, :datetime
    add_index :users, :send_welcome_email_at
  end
end
