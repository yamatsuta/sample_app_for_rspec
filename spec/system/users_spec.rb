require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      before do
        visit sign_up_path
      end
      context 'フォームの入力値が正常の時' do
        before do
          fill_in 'Email', with: 'email@example.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成が成功する' do
          expect(current_path).to eq login_path
          expect(page).to have_content "User was successfully created."
        end
      end

      context 'メールアドレスが未入力の時' do
        before do
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規登録が失敗する' do
          expect(current_path).to eq users_path
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '登録済のメールアドレスを使用した時' do
        before do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
        end
        it 'ユーザーの新規登録が失敗する' do
          expect(current_path).to eq users_path
          expect(page).to have_content "Email has already been taken"
          expect(page).to have_field 'Email', with: user.email
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない時' do
        before do
          visit user_path(user)
        end
        it 'マイページへのアクセスが失敗する' do
          expect(current_path).to eq login_path
          expect(page).to have_content "Login required"
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      login(user)
    end
    describe 'ユーザー編集' do
      before do
        visit edit_user_path(user)
      end
      context 'フォームの入力値が正常の時' do
        before do
          fill_in 'Email', with: 'update_email@example.com'
          fill_in 'Password', with: 'update_password'
          fill_in 'Password confirmation', with: 'update_password'
          click_button 'Update'
        end
        it 'ユーザーの編集が成功する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "User was successfully updated."
        end
      end

      context 'メールアドレスが未入力の時' do
        before do
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'update_password'
          fill_in 'Password confirmation', with: 'update_password'
          click_button 'Update'
        end
        it 'ユーザーの編集が失敗する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '登録済のメールアドレスを使用した時' do
        before do
          fill_in 'Email', with: another_user.email
          fill_in 'Password', with: 'update_password'
          fill_in 'Password confirmation', with: 'update_password'
          click_button 'Update'
        end
        it 'ユーザーの編集が失敗する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email has already been taken"
        end
      end

      context '他ユーザーの編集ページにアクセスした時' do
        before do
          visit edit_user_path(another_user)
        end
        it '編集ページへのアクセスが失敗する' do
          expect(page).to have_content "Forbidden access."
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成した時' do
        before do
          task = create(:task, title: 'new_task', status: 'doing', user: user)
          visit user_path(user)
        end
        it '新規作成したタスクが表示される' do
          expect(page).to have_content 'new_task'
          expect(page).to have_content 'doing'
          expect(page).to have_content 'Show'
          expect(page).to have_content 'Edit'
          expect(page).to have_content 'Destroy'
        end
      end
    end
  end
end
