class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :event_type, null: false
      t.jsonb :payload, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :events, :event_type
  end
end
