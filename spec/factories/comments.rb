FactoryBot.define do
  factory :comment do
    association(:commentable)
    body { "Test Comment" }
    author factory: :user
  end
end
