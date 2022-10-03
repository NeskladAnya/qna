FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    question
    author factory: :user

    trait :with_attached_files do
      after(:create) do |answer|
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/rails_helper.rb"),
          filename: 'rails_helper.rb'
        )
      end
    end

    trait :with_links do
      after(:create) do |answer|
        create(:link, linkable: answer)
      end
    end

    trait :invalid do
      body { nil }
    end
  end
end
