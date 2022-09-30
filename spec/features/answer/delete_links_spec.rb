require 'rails_helper'

feature 'An authorized user can delete answer links', %q{
  Given I'm signed in
  And I'm on the question page
  And I'm the author of the answer
  And the answer has a link
  Then I should be able to delete the link
} do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, :with_links, author: user, question: question) }

  scenario 'User deletes a link', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answer-links' do
      click_on 'Delete'
    end

    expect(page).to_not have_link 'MyString'
  end
end
