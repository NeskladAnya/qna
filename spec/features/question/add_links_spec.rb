require 'rails_helper'

feature 'An authorized user can add links to the question', %q{
  Given I'm signed in
  When I create a new question
  Or edit an existing one
  Then I should be able to add links
} do
  
  given(:user) { create(:user) }
  given(:url) { 'https://google.com' }
  given!(:question) { create(:question, author: user) }

  scenario 'User adds a link when creates a new question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test body'

    fill_in 'Link name', with: 'Test link name'
    fill_in 'URL', with: url

    click_button 'Ask'

    expect(page).to have_link 'Test link name', href: url
  end

  scenario 'User adds a link when edits an existing question', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Edit question'

    within '.question-edit-form' do
      click_on 'Add link'

      fill_in 'Link name', with: 'Test link name'
      fill_in 'URL', with: url
    end

    click_button 'Save'

    expect(page).to have_link 'Test link name', href: url
  end
end
