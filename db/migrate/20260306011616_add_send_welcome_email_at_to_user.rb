class AddSendWelcomeEmailAtToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :send_welcome_email_at, :datetime
  end
end
