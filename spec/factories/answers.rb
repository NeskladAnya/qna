FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    question
    author factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
