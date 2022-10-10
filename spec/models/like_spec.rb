require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to :likeable }

  it { should validate_presence_of :user }
  it { should validate_presence_of :value }
end
