require 'rails_helper'

feature 'The author of the question can delete it', %q{
  Given I'm the author of the question
  And I'm signed in
  Then I should be able to delete the question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'An author deletes the question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question deleted'
  end

  scenario 'A user who is not the author tries to delete the question' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
