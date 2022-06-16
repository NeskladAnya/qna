require 'rails_helper'

feature 'A user can sign out', %q{
  Given I'm on the web-site
  And I'm logged in
  Then I should be able to log out
} do
  
  given(:user) { create(:user) }

  scenario 'A user signs out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
