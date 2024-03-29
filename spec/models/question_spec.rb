require 'rails_helper'
require Rails.root.join('spec/models/concerns/likeable_spec.rb')

RSpec.describe Question, type: :model do
  it { should belong_to(:author).class_name('User') }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(5) }

  it { should accept_nested_attributes_for :reward }
  it { should accept_nested_attributes_for :links }

  it 'has several attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'likeable'

  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) {build(:question, author: user)}

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
