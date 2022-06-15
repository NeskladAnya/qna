require 'rails_helper'

feature 'A user can view all existing questions', %q{
  Given I'm a user
  When I'm on the questions page
  Then I should see all existing questions
} do

  describe 'Questions exist' do
    given!(:question) { create(:question) }

    scenario 'a user sees them on the questions page' do
      visit questions_path
      
      expect(page).to have_content question.title
    end
  end

  describe 'Questions do not exist' do
    scenario 'a user does not see any questions on the questions page' do
      visit questions_path

      expect(page).to have_content 'No questions found'
    end
  end
end
