require 'rails_helper'

feature 'An authorized user can subscribe to a question updates', %q{
  Given I'm an authorized user
  When I'm on the question page
  Then I should be able to subscribe to the question
} do
  
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, :with_subscription, author: user) }

  describe 'The author of the question' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'has already subscribed' do
      expect(page).to have_button 'Unsubscribe'
    end

    scenario 'unsubscribes' do
      click_on('Unsubscribe')
      expect(page).to have_button 'Subscribe'
    end
  end

  describe 'Not the author of the question' do
    background do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'has not subscribed' do
      expect(page).to have_button 'Subscribe'
    end

    scenario 'unsubscribes' do
      click_on('Subscribe')
      expect(page).to have_button 'Unsubscribe'
    end
    
  end
end
