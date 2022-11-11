require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :subscribable}

  it { should validate_presence_of :user }
end
