RSpec.describe Like, type: :model do
  it { should belong_to :likeable}
  it { should belong_to :user } 

  it { should validate_presence_of :value }
end
