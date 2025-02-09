class AddChargebeeEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :chargebee_events, id: false do |t|
      t.string :event_id, null: false
      t.datetime :created_at, null: false, index: true
      t.string :event_type, null: false, index: true
      t.string :user_email, null: false, index: true
      t.jsonb :content
    end
    add_index :chargebee_events, :event_id, unique: true
    add_index :chargebee_events, :content, using: :gin, name: :chargebee_events_idx
  end
end
