require 'rails_helper'

feature 'An authorized user can delete question links', %q{
  Given I'm signed in
  And I'm on the question page
  And I'm the author of the question
  And the question has a link
  Then I should be able to delete the link
} do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_links, author: user) }

  scenario 'User deletes a link', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question-links' do
      click_on 'Delete'
    end

    expect(page).to_not have_link 'MyString'
  end
end
