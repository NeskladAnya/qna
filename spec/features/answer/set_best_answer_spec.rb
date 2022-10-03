require 'rails_helper'

feature 'An author of the question can select one best answer', %q{
  Given I'm the author of the question
  And I'm signed in
  Then I should be able to select one best answer
  And I should be able to change the best answer if it has been already selected
} do

  given(:user) { create(:user) }
  given(:user2) {create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user2) }

  describe 'The author of the question', js: true do
    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'selects the best answer for the first time' do
      expect(page).to_not have_content 'Best answer:'
      click_on 'Best'

      within '.best-answer' do
        expect(page).to have_content answer.body
      end
    end

    scenario 'selects a new best answer' do
      click_on 'Best'

      fill_in 'answer[body]', with: 'New answer'
      click_on 'Add answer'

      within '.other-answers' do
        click_on 'Best'
      end

      within '.best-answer' do
        expect(page).to have_content 'New answer'
      end
    end
  end

  describe 'Not the author of the question' do
    scenario 'cannot select the best answer' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Best'
    end
  end
end
