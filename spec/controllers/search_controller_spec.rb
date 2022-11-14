require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    before { get :search, params: { option: 'question', context: 'search' } }

    it 'renders search view' do
      expect(response).to render_template :search
    end
  end
end
