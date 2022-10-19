require 'rails_helper'

feature 'An authorized user can add a comment to a question', %q{
  Given I'm an authorized user
  When I'm on the question page
  Then I should be able to add a comment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'An authorized user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds a new comment' do
      click_on 'Add comment'

      within '.comments' do
        fill_in 'Test comment'
        click_on 'Add comment'

        expect(page).to have_content 'Test comment'
      end 
    end
  end

  describe 'Multiple sessions', js: true do
    scenario "a new comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Add comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test comment'
      end
    end
  end
end
