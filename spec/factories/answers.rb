FactoryBot.define do
  factory :answer do
    association :question
    body { "MyString" }

    trait :invalid do
      body { nil }
    end
  end
end
