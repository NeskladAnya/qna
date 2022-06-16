require 'rails_helper'

feature 'A user can sign in', %q{
  Given I'm on the web-site
  And I'm not signed in
  And I'm signed out
  Then I should be able to sign in
} do

  given(:user) { create(:user) }
  
  describe 'A user is not signed in:' do
    background { visit new_user_session_path }

    scenario 'the data is valid' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_on 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'the data is invalid' do
      fill_in 'Email', with: 'incorrect@gmail.com'
      fill_in 'Password', with: user.password

      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  describe 'A user is already signed in' do
    scenario 'and tries to sign in again' do
      sign_in(user)
      visit new_user_session_path

      expect(page).to have_content 'You are already signed in.'
    end
  end
end
