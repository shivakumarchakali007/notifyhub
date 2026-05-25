FactoryBot.define do
  factory :notification do
    user { nil }
    event { nil }
    channel { "MyString" }
    status { "MyString" }
  end
end
