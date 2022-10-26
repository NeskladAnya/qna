require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).class_name('Question').dependent(:destroy) }
  it { should have_many(:answers).class_name('Answer').dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many :rewards }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }
    
    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
