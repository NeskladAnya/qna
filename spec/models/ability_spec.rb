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
    let(:other) { create(:user) }
    let(:question) { create(:question, author: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, create(:question, author: other) }

    it { should be_able_to :update, create(:answer, author: user) }
    it { should_not be_able_to :update, create(:answer, author: other) }
    it { should be_able_to :set_best, create(:answer, question: question) }
  end
end
