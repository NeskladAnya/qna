require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_links, author: user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    it 'deletes the link' do
      expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(question.links, :count).by(-1)
    end
  end
end
