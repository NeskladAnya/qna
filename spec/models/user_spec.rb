require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).class_name('Question').dependent(:destroy) }
  it { should have_many(:answers).class_name('Answer').dependent(:destroy) }
  it { should have_many(:likes).dependent(:destroy) }
  it { should have_many :rewards }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    context 'a user is already authorized' do
      it 'returns the user' do
        user.authorizations.create(provider: 'github', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'a user is not authorized' do
      context 'the user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }
        
        it 'does not create a new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates a new authorization for the user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates an authorization with the provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'the user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates a new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        
        it 'returns a new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills the user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates a new authorization for the user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates an authorization with the provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
