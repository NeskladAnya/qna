FactoryBot.define do
  factory :link do
    association(:linkable)
    
    name { "MyString" }
    url { "https://test.com" }
  end
end
