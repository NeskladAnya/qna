require 'rails_helper'

feature 'An authorized user can like or dislike a question', %q{
  Given I'm an authorized user
  And I'm not the author of the question
  When I'm on the question page
  Then I should be able to like or dislike the question
} do
  
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'The author of the question' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'cannot like the question' do
      expect(page).to have_link('', class: "bi-hand-thumbs-up disabled")
      expect(page).to have_link('', class: "bi-hand-thumbs-down disabled")
    end

    scenario 'cannot dislike the question'
  end

  describe 'Not the author of the question' do
    background do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'likes the question' do
      click_on('', class: "bi-hand-thumbs-up")

      expect(page).to have_link('', class: "bi-hand-thumbs-up-fill")
      within '.like' do
        expect(page).to have_content '1'
      end
    end

    scenario 'dislikes the question'
  end
end
