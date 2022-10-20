require 'rails_helper'

feature 'An authorized user can add a new answer to the question', %q{
  Given I'm an authorized user
  When I'm on the question page
  Then I should be able to add an answer to the displayed question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'An authorized user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds a new answer' do
      fill_in 'answer[body]', with: 'Test Answer'
      click_on 'Add answer'

      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'Test Answer'
      end
    end

    scenario 'adds a new answer with attached files' do
      fill_in 'answer[body]', with: 'Test Answer'
      attach_file ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Add answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'tries to save an invalid answer' do
      click_on 'Add answer'
  
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'An anauthorized user tries to add a new answer' do
    visit question_path(question)

    expect(page).to_not have_button 'Add answer'
  end

  describe 'Multiple sessions', js: true do
    scenario "a new answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer[body]', with: 'Test Answer'
        click_on 'Add answer'

        expect(current_path).to eq question_path(question)

        within '.answers' do
          expect(page).to have_content 'Test Answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test Answer'
      end
    end
  end
end
