class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :channel, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end
    add_index :notifications, [ :user_id, :event_id, :channel ], unique: true
    add_index :notifications, [ :status, :channel ]
  end
end
