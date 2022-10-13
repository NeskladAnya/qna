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

  describe 'Not the author of the question', js: true do
    background do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'likes the question' do
      within '.question-body' do
        click_on('', class: "like")

        expect(page).to have_content('1')
      end
    end

    scenario 'dislikes the question' do
      within '.question-body' do
        click_on('', class: "dislike")

        expect(page).to have_content('-1')
      end
    end
  end
end
