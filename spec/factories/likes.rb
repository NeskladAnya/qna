FactoryBot.define do
  factory :like do
    association(:likeable)
    user
  end
end
