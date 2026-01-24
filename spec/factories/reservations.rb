FactoryBot.define do
  factory :reservation do
    user
    harvest_experience
    number_of_people { 2 }
    reserved_at { Time.current }
  end
end
