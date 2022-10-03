FactoryBot.define do
  factory :reward do
    name { "MyReward" }
    question
    answer
    user

    after(:create) do |reward|
      reward.image.attach(
        io: File.open("#{Rails.root}/spec/smarty_pants.png"),
        filename: 'smarty_pants.png'
      )
    end

    trait :invalid do
      name { nil }
    end
  end
end
