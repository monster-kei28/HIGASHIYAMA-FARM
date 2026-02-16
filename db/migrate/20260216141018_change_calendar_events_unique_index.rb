class ChangeCalendarEventsUniqueIndex < ActiveRecord::Migration[7.2]
  def change
    remove_index :calendar_events, column: [ :event_date, :kind ]
    add_index :calendar_events, :event_date, unique: true
  end
end
