class AddWelcomEmailSentAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :welcome_email_sent_at, :datetime
  end
end
