require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for a guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for a user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, :with_links, :with_attached_files, author: user) }
    let(:other_question) { create(:question, :with_links, :with_attached_files, author: other_user) }
    let(:answer) { create(:answer, :with_links, :with_attached_files, question: question, author: user) }
    let(:other_answer) { create(:answer, :with_links, :with_attached_files, question: other_question, author: other_user) }
    let(:reward) { create(:reward, user: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :destroy, question}
    it { should_not be_able_to :destroy, other_question}

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }
    it { should be_able_to :set_best, answer }
    it { should_not be_able_to :set_best, other_answer }
    it { should be_able_to :destroy, answer}
    it { should_not be_able_to :destroy, other_answer}

    it { should be_able_to :show, reward }

    it { should be_able_to :create_comment, question }
    it { should be_able_to :create_comment, answer }

    it { should be_able_to :like, other_question}
    it { should_not be_able_to :like, question}
    it { should be_able_to :like, other_answer}
    it { should_not be_able_to :like, answer}
    it { should be_able_to :dislike, other_question}
    it { should_not be_able_to :dislike, question}
    it { should be_able_to :dislike, other_answer}
    it { should_not be_able_to :dislike, answer}

    it { should be_able_to :destroy, question.links.first }
    it { should_not be_able_to :destroy, other_question.links.first }
    it { should be_able_to :destroy, answer.links.first }
    it { should_not be_able_to :destroy, other_answer.links.first }

    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, other_question.files.first }
    it { should be_able_to :destroy, answer.files.first }
    it { should_not be_able_to :destroy, other_answer.files.first }
  end
end
