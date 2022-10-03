require 'rails_helper'

feature 'An authorized user can view received rewards', %q{
  Given I'm signed in
  And I have a reward
  When I'm on the reward page
  Then I should be able to see all received rewards
} do
  
  given!(:user) { create(:user) }
  given(:user2) { create(:user) }

  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:reward) { create(:reward, question: question, answer: answer, user: user) }

  describe 'An authorized user' do

    scenario 'visits the reward page and has a reward' do
      sign_in(user)
      visit rewards_path

      expect(page).to have_content reward.name
      expect(page).to have_content reward.question.title
    end

    scenario 'visits the reward page and has no rewards' do
      sign_in(user2)
      visit rewards_path

      expect(page).to_not have_content reward.name
    end
  end

  describe 'An unauthorized user' do

     scenario 'tries to visit the reward page' do
      visit root_path
      expect(page).to_not have_content 'Rewards'
     end
  end
end
