require 'rails_helper'

feature 'An authorized user can create a new reward', %q{
  Given I'm signed in
  When I'm on a new question page
  Then I should be able to create a new reward
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'A user creates a new reward' do
    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test body'

    fill_in 'Name', with: 'Test name'

    within '.reward-file' do
      attach_file "#{Rails.root}/spec/smarty_pants.png"
    end

    click_button 'Ask'

    expect(Question.last.reward).to eq Reward.last
  end

  scenario 'A user tries to create a new reward with an empty name' do
    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test body'

    within '.reward-file' do
      attach_file "#{Rails.root}/spec/smarty_pants.png"
    end

    click_button 'Ask'

    expect(Question.last.reward).to eq nil
  end
end
