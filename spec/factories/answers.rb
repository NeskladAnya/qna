FactoryBot.define do
  factory :answer do
    body { "MyString" }
    question
    author factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
