FactoryBot.define do
  factory :user do
    name { '山田太郎' }
    sequence(:phone_number) { |n| "0901234#{format('%04d', n)}" }
  end
end
