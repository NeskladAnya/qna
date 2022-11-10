require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('NotificationService') }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, author: user, question: question) }

  before { allow(NotificationService).to receive(:new).and_return(service) }

  it 'calls NotificationService#send_notification' do
    expect(service).to receive(:send_notification)
    described_class.perform_now(answer)
  end
end
