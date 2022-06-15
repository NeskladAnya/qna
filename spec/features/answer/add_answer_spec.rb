require 'rails_helper'

feature 'A user can add a new answer to the question', %q{
  Given I'm a user
  When I'm on the question page
  Then I should be able to add an answer to the displayed question
} do

  given(:question) { create(:question) }

  background { visit question_path(question) }
  
  scenario 'A user adds a new answer' do
    fill_in 'answer[body]', with: 'Test Answer'
    click_on 'Add answer'

    expect(page).to have_content 'Test Answer'
  end

  scenario 'A user tries to save an invalid answer' do
    click_on 'Add answer'

    expect(page).to_not have_content 'Test Answer'
  end
end
