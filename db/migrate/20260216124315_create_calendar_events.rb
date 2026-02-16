class CreateCalendarEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :calendar_events do |t|
      t.date :event_date, null: false
      t.integer :kind, null: false, default: 0
      t.string :note
      t.timestamps
    end

    add_index :calendar_events, [ :event_date, :kind ], unique: true
  end
end
