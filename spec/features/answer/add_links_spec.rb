require 'rails_helper'

feature 'An authorized user can add links to the answer', %q{
  Given I'm signed in
  When I create a new answer
  Or edit an existing one
  Then I should be able to add links
} do
  
  given(:user) { create(:user) }
  given(:url) { 'https://google.com' }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'User adds a link when creates a new answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'answer[body]', with: 'Test body'

      click_on 'Add link'

      fill_in 'Link name', with: 'Test link name'
      fill_in 'URL', with: url
    end

    click_button 'Add answer'

    within '.other-answers' do
      expect(page).to have_link 'Test link name', href: url
    end
  end

  scenario 'User adds a link when edits an existing answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.other-answers' do
      click_on 'Edit'

      click_on 'Add link'

      fill_in 'Link name', with: 'Test link name'
      fill_in 'URL', with: url
    end

    click_button 'Save'

    expect(page).to have_link 'Test link name', href: url
  end
end
