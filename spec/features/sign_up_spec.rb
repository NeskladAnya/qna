require 'rails_helper'

feature 'A user can sign up', %q{
  Given I'm on the web-site
  And I'm not signed in
  Then I should be able to sign up
} do

  describe 'A user signs up with valid data' do  
    scenario 'the email is not taken' do
      visit new_user_registration_path

      fill_in 'Email', with: 'test@gmail.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'

      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end
  end

  describe 'A user tries to sign up with invalid data:' do
    given(:user) { create(:user) }
    background { visit new_user_registration_path }

    scenario 'the email has already been taken' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation

      click_button 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end

    scenario 'fields are empty' do
      click_button 'Sign up'

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end

    scenario 'the user is already signed in' do
      sign_in(user)
      visit new_user_registration_path

      expect(page).to have_content 'You are already signed in.'
    end
  end
end
