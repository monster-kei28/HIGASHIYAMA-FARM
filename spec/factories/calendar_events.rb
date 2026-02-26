FactoryBot.define do
  factory :calendar_event do
    sequence(:event_date) { |n| Date.current + (n + 5).days } # ✅ 毎回違う日付になる
    kind { :open }
    note { nil }

    trait :closed do
      kind { :closed }
    end
  end
end
