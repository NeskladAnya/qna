require 'rails_helper'

feature 'An authorized user can create a new question', %q{
  Given I'm signed in
  When I'm on the questions page
  Then I should be able to create a new question
} do

  given(:user) { create(:user) }

  scenario 'An authorized user creates a new question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test body'
    click_button 'Ask'

    expect(page).to have_content 'Question created'
  end

  scenario 'An unauthorized user tries to create a new question' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end
end
