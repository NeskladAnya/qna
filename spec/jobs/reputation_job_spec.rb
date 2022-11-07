require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) {create(:question, author: user)}

  it 'calls ReputationJob' do
    expect(ReputationJob).to receive(:perform_later).with(question)
    ReputationJob.perform_now(question)
  end
end
