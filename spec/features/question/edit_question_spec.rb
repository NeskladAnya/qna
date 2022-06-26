require 'rails_helper'

feature 'The author of the question can edit it', %q{
  Given I'm the author of the question
  And I'm signed in
  Then I should be able to edit the question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  
  describe 'An authorized user', js: true do
    scenario 'is the author of the question and edits it with valid attributes' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question-edit-form' do
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New qeustion body'
        click_button 'Save'

        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to_not have_content question.body
      expect(page).to have_content 'New title'
      expect(page).to have_content 'New qeustion body'
    end

    scenario 'is the author of the answer and tries to edit it with invalid attributes' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question-edit-form' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_button 'Save'
      end

      expect(page).to have_content question.body
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'is not the author of the answer and cannot edit it' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end

  scenario 'An anauthorized user cannot edit the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

end
