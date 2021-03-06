require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).class_name('Question').dependent(:destroy) }
  it { should have_many(:answers).class_name('Answer').dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
