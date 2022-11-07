shared_examples 'add_comments' do
  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates a comment to resource' do
      within resource_class do
        click_link 'Add comment'
        fill_in 'comment[body]', with: 'text text text'
        click_button 'Comment'

        expect(page).to have_current_path question_path(question), ignore_query: true
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'creates a comment to resource with error' do
      within resource_class do
        click_link 'Add comment'
        fill_in 'comment[body]', with: ''
        click_button 'Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries trying to create a comment to resource' do
    visit question_path(question)

    within resource_class do
      expect(page).to_not have_link 'Add comment'
    end
  end

  context 'multiple sessions', js: true do
    scenario "comment to the resource appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(resource_comment)
      end

      Capybara.using_session('guest') do
        visit question_path(resource_comment)
      end

      Capybara.using_session('user') do
        within resource_class do
          click_link 'Add comment'
          fill_in 'comment[body]', with: 'text text text'
          click_button 'Comment'

          expect(page).to have_content 'text text text'
          expect(page).to_not have_selector 'textarea'
        end
      end

      Capybara.using_session('guest') do
        within resource_class do
          expect(page).to have_content 'text text text'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end
  end
end
