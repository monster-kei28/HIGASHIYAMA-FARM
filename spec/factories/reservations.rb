FactoryBot.define do
  factory :reservation do
    user
    harvest_experience
    number_of_people { 2 }

    transient do
      reservation_date { Date.current + 7.days } # ✅ 17時締切の影響を受けにくい
    end

    after(:build) do |reservation, evaluator|
      # ✅ その日を営業日にしておく（closed 判定に引っかからない）
      CalendarEvent.find_or_create_by!(event_date: evaluator.reservation_date) do |e|
        e.kind = :open
      end

      reservation.reserved_date = evaluator.reservation_date
      reservation.reserved_time = "10:00"
    end
  end
end
