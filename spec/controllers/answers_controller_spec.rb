require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders the create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer to the db' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end

      it 'renders the create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user) }
    let(:user2) { create(:user) }

    context 'with valid attributes' do
      it 'the author changes answer attributes' do
        login(user)

        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'New body'
      end

      it 'not the author does not change answer attributes' do
        login(user2)

        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js
        answer.reload
        
        expect(answer.body).to_not eq 'New body'
      end

      it 'renders an updated view' do
        login(user)
        
        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      
      it 'does not change answer attributets' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders an updated view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
