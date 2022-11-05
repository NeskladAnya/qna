shared_examples 'voting' do
  describe 'Unauthenticated user' do
    scenario "can't to change resource rating by voting" do
      visit question_path(question)

      expect(page).to_not have_link 'Cancel vote'
      expect(page).to_not have_link 'UP'
      expect(page).to_not have_link 'DOWN'
    end
  end

  describe 'Authenticated author' do
    scenario 'tries to change resource rating by voting' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Cancel vote'
      expect(page).to_not have_link 'UP'
      expect(page).to_not have_link 'DOWN'
    end
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(not_author)
      visit question_path(question)
    end

    scenario 'vote up a resource' do
      within resource_class do
        click_on 'UP'

        expect(page).to have_content '1'
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'
      end
    end

    scenario 'vote down a resource' do
      within resource_class do
        click_on 'DOWN'

        expect(page).to have_content '-1'
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'
      end
    end

    scenario 'vote cancel a resource' do
      within resource_class do
        click_on 'UP'

        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'

        click_on 'Cancel vote'

        expect(page).to have_content '0'
        expect(page).to_not have_link 'Cancel vote'
        expect(page).to have_link 'UP'
        expect(page).to have_link 'DOWN'
      end
    end
  end
end
