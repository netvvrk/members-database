class CreateWelcomeEmails < ActiveRecord::Migration[7.2]
  def change
    create_table :welcome_emails do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :send_at
      t.datetime :sent_at

      t.timestamps
    end
  end
end
