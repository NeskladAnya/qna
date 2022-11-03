require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCPET" => "application.json" } }

  describe 'GET /api/v1/users' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/users' }
    it_behaves_like 'API Authorizable'

    let(:access_token) { create(:access_token) }
    let(:user_response) { json['users'].first }
    let!(:users) { create_list(:user, 5) }
    let(:user) { users.first }
    let(:me) { create(:user) }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns a list of users' do
      expect(json['users'].size).to eq users.size
    end

    it 'does not return the current user in the list' do
      json['users'].each do |user|
        expect(user['id']).to_not eq me.id
      end
    end

    it 'returns all public fields' do
      %w[id email admin created_at updated_at].each do |attr|
        expect(user_response[attr]).to eq user.send(attr).as_json
      end
    end

    it 'does not return private fields' do
      %w[password encrypted_password].each do |attr|
        expect(json).to_not have_key(attr)
      end
    end
  end
end
