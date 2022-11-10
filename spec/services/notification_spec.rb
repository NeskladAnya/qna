require 'rails_helper'

RSpec.describe Services::Notification do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_subscription, author: user) }
  let(:answer) { create(:answer, author: user, question: question) }

  it 'sends notifications about a new answer added to the question' do
    question.subscriptions.each do |subscription|
      expect(NotificationMailer).to receive(:subscribe_question).with(subscription.user, answer).and_call_original
    end
    subject.send_notification(answer)
  end
end
