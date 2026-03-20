FactoryBot.define do
  factory :page_image do
    page_type { 1 }
    slot { 1 }
    image { "MyString" }
    position { 1 }
    published { false }
  end
end
