require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_attached_files, author: user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    it 'deletes the attached file' do
      expect{ delete :destroy, params: { id: question.files.first } }.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    it 'redirects to the question show view' do
      delete :destroy, params: { id: question.files.first }
      expect(response).to redirect_to question_path(question)
    end
  end
end
