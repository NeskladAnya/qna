require 'rails_helper'

feature 'An authorized user can like or dislike an answer', %q{
  Given I'm an authorized user
  And I'm not the author of the answer
  When I'm on the question page
  Then I should be able to like or dislike the answer
} do
  
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Not the author of the answer', js: true do
    background do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'likes the answer' do
      within '.answers' do
        save_and_open_page
        click_on('', class: "like")

        expect(page).to have_content('1')
      end
    end

    scenario 'dislikes the question' do
      within '.answers' do
        click_on('', class: "dislike")

        expect(page).to have_content('-1')
      end
    end
  end
end
