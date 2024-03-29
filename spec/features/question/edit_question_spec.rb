require 'rails_helper'

feature 'The author of the question can edit it', %q{
  Given I'm the author of the question
  And I'm signed in
  Then I should be able to edit the question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:question2) { create(:question, :with_attached_files, author: user) }
  
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

    scenario 'is the author of the question and edits it by attaching files' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question-edit-form' do
        attach_file ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_button 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'is the author of the question and removes an attached file' do
      sign_in(user)
      visit question_path(question2)
      
      within '.question-files' do
        click_link 'Delete'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'is not the author of the question and cannot edit it' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end

    scenario 'is not the author of the question and cannot remove an attached file' do
      sign_in(user2)
      visit question_path(question2)

      expect(page).to_not have_link 'Remove'
    end
  end

  scenario 'An anauthorized user cannot edit the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

end
