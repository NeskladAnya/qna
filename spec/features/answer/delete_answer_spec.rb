require 'rails_helper'

feature 'The author of the answer can delete it', %q{
  Given I'm the author of the answer
  And I'm signed in
  Then I should be able to delete the answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'An author deletes the answer', js: true do
    sign_in(user)
    
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'A user who is not the author tries to delete the question' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
