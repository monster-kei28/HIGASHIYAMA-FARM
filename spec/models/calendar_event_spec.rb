# spec/models/calendar_event_spec.rb
require "rails_helper"

RSpec.describe CalendarEvent, type: :model do
  describe "validations" do
    it "event_date があれば有効" do
      event = CalendarEvent.new(event_date: Date.current, kind: :open)
      expect(event).to be_valid
    end

    it "event_date がないと無効" do
      event = CalendarEvent.new(kind: :open)
      expect(event).to be_invalid
    end
  end

  describe "enum" do
    it "open / closed が使える" do
      event = CalendarEvent.new(event_date: Date.current, kind: :closed)
      expect(event.closed?).to be true
    end
  end
end
