require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to :question }
  it { should have_one :reward }
  
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }

  it 'has several attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
