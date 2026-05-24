FactoryBot.define do
  factory :event do
    event_type { "MyString" }
    payload { "" }
    user { nil }
  end
end
