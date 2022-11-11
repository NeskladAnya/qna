FactoryBot.define do
  factory :subscription do
    association(:subscribable)
    user
  end
end
