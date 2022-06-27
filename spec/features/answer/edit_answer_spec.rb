require 'rails_helper'

feature 'The author of the answer can edit it', %q{
  Given I'm the author of the answer
  And I'm signed in
  Then I should be able to edit the answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, :with_attached_files, question: question, author: user) }
  
  describe 'An authorized user', js: true do
    scenario 'is the author of the answer and edits it with valid attributes' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'New answer body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'New answer body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'is the author of the answer and tries to edit it with invalid attributes' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'is the author of the answer and edits it by attaching files' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_button 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'is the author of the answer and removes an attached file' do
      sign_in(user)
      visit question_path(question)
      
      click_link 'Remove'
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'is not the author of the answer and cannot edit it' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end

    scenario 'is not the author of the answer and cannot remove an attached file' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Remove'
    end
  end

  scenario 'An anauthorized user cannot edit the answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

end
