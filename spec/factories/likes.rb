FactoryBot.define do
  factory :like do
    association(:likeable)
    value { 1 }
    user
  end
end
