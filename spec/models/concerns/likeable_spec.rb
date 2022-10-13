require 'rails_helper'

RSpec.shared_examples_for 'likeable' do
  it { should have_many(:likes).dependent(:destroy) }

  let(:likeable) { create(described_class.to_s.underscore.to_sym, author: user) }

  describe 'all' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }

    it 'likes' do
      likeable.like(user)

      expect(likeable.likes.last.value).to eq 1
    end

    it 'dislikes' do
      likeable.dislike(user)

      expect(likeable.likes.last.value).to eq -1
    end

    it 'clears rating' do
      likeable.clear_rating(user)

      expect(likeable.likes.count).to eq 0
    end

    it 'already liked?' do
      likeable.like(user)

      expect(likeable.already_liked?(user)).to eq true
    end

    it 'already_disliked?' do
      likeable.dislike(user)

      expect(likeable.already_disliked?(user)).to eq true
    end

    it 'sums the rating' do
      likeable.like(user)
      likeable.like(user2)

      expect(likeable.final_rating).to eq 2
    end
  end
end
