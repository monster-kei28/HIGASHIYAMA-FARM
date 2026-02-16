FactoryBot.define do
  factory :calendar_event do
    event_date { "2026-02-16" }
    kind { 1 }
    note { "MyString" }
  end
end
