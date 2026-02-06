FactoryBot.define do
  factory :user do
    name { "山田太郎" }
    sequence(:phone_number) { |n| "0901234#{format('%04d', n)}" }

    # LINEログイン直後（未完成ユーザー）用
    trait :line_login do
      provider { "line" }
      sequence(:uid) { |n| "U-test-uid-#{n}" }
      name { nil }
      phone_number { nil }
    end
  end
end
