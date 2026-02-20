FactoryBot.define do
  factory :reservation do
    user
    harvest_experience
    number_of_people { 2 }
    reserved_date { Date.current }
    reserved_time { "10:00" }
  end
end
