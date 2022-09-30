FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    author factory: :user
    
    trait :with_attached_files do
      after(:create) do |question|
        question.files.attach(
          io: File.open("#{Rails.root}/spec/rails_helper.rb"),
          filename: 'rails_helper.rb'
        )
      end
    end

    trait :with_links do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end

    trait :invalid do
      title { nil }
    end
  end
end
