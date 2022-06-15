require 'rails_helper'

feature 'A user can view a question', %q{
  Given I'm a user
  When I'm on the question page
  Then I should see the question info
  And I should see question answers
  And I should see the Add new answer form
} do

  given(:question) { create(:question) }

  background { visit question_path(question) }

  scenario 'A user sees the question info' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'A user sees the Add new answer form' do
    expect(page).to have_button 'Add answer'
  end

  describe 'The question has answers' do
    given!(:answers) { create_list(:answer, 2, question: question ) }

    scenario 'a user sees question answers' do
      visit question_path(question)
      expect(page).to have_content 'All answers'
    end
  end

  describe 'The question does not have answers' do
    scenario 'a user does not see question answers' do
      visit question_path(question)
      expect(page).to_not have_content 'All answers'
    end
  end
end
