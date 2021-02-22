require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let!(:user) { create(:user, email: 'email@example.com', password: 'password') }
  describe 'ログイン前' do
    before do
      visit login_path
    end
    context 'フォームの入力値が正常の時' do
      before do
        fill_in 'Email', with: 'email@example.com'
        fill_in 'Password', with: 'password'
        click_button 'Login'
      end
      it 'ログイン処理が成功する' do
        expect(current_path).to eq root_path
        expect(page).to have_content "Login successful"
      end
    end

    context 'フォームが未入力の時' do
      before do
        fill_in 'Email', with: nil
        fill_in 'Password', with: nil
        click_button 'Login'
      end
      it 'ログイン処理が失敗する' do
        expect(current_path).to eq login_path
        expect(page).to have_content "Login failed"
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリックした時' do
      before do
        login(user)
        click_link 'Logout'
      end
      it 'ログアウト処理が成功する' do
        expect(current_path).to eq root_path
        expect(page).to have_content "Logged out"
      end
    end
  end
end
