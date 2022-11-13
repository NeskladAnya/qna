require 'sphinx_helper'

feature 'A user can search records through the search bar', %q{
  Given I'm a user
  And I'm on the root_path
  And I'd like to search some text
  Then I should be able to use search
} do

  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  describe 'Search', sphinx: true, js: true do
    context 'an existing record' do
      it 'via global search' do
        visit root_path

        ThinkingSphinx::Test.run do
          fill_in 'context', with: question.body
          click_button 'Search'

          expect(page).to have_content 'Question'
          expect(page).to have_content question.body
        end
      end

      it 'via question search' do
        visit root_path

        ThinkingSphinx::Test.run do
          fill_in 'context', with: 'extraterrestial'
          select 'Questions', from: 'option'
          click_button 'Search'

          expect(page).to have_content 'Question'
          expect(page).to have_content 'extraterrestial'
        end
      end
    end

    it 'non-existing record' do
      visit root_path

      ThinkingSphinx::Test.run do
        fill_in 'context', with: 'sophisticated'
        click_button 'Search'

        expect(page).to_not have_content 'sophisticated'
      end
    end
  end
end
