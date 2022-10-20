require 'rails_helper'

feature 'An authorized user can create a new question', %q{
  Given I'm signed in
  When I'm on the questions page
  Then I should be able to create a new question
} do

  given(:user) { create(:user) }

  describe 'An authorized user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test title'
      fill_in 'Body', with: 'Test body'
    end

    scenario 'creates a new question without attached files' do
      click_button 'Ask'

      expect(page).to have_content 'Question created'
    end

    scenario 'creates a new question with attached files' do
      within '.question-files' do
        attach_file ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      end
      
      click_button 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'An unauthorized user tries to create a new question' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end

  describe 'Multiple sessions', js: true do
    scenario "a new question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Test title'
        fill_in 'Body', with: 'Test body'

        click_button 'Ask'

        expect(page).to have_content 'Question created'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test title'
      end
    end
  end
end
