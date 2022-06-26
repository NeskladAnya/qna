require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
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

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }

    before { login(user) }

    context 'the author is logged in' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders an updated view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end 
    end

    context 'not the author is logged in' do
      before { login(user2) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'POST #set_best' do
    context 'the author of the question is logged in' do
      before do 
        login(user)
        post :set_best, params: { id: answer }, format: :js
        question.reload
      end

      it 'sets the best answer' do
        expect(question.best_answer).to eq answer
      end

      it 'renders the set-best view' do
        expect(response).to render_template :set_best
      end
    end
    
    context 'not the author of the question is logged in' do
      before { login(user2) }

      it 'does not set the best answer' do
        post :set_best, params: { id: answer }, format: :js
        question.reload

        expect(question.best_answer).to eq nil
      end
    end
  end
end
