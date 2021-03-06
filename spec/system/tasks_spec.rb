require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:task) { create(:task, user: user) }
  describe 'ログイン前' do
    shared_examples_for 'ページへのアクセスが失敗しログイン画面に飛ばされる' do
      it { 
        expect(current_path).to eq login_path
        expect(page).to have_content "Login required"
       }
    context 'タスク新規登録ページへアクセスした時' do
      before do
        visit new_task_path
      end
      it_behaves_like 'ページへのアクセスが失敗しログイン画面に飛ばされる'
    end

    context 'タスク編集ページへアクセスした時' do
      before do
        visit edit_task_path(task)
      end
      it_behaves_like 'ページへのアクセスが失敗しログイン画面に飛ばされる'
    end

    context 'タスクの詳細ページへアクセスした時' do
      before do
        visit task_path(task)
      end
      it 'タスクの詳細情報が表示される' do
        expect(page).to have_content task.title
        expect(current_path).to eq task_path(task)
      end
    end

    context 'タスクの一覧ページへアクセスした時' do
      before do
        visit tasks_path
        task_list = create(:task, 3)
      end
      it '全てのユーザーのタスク情報が表示される' do
        expect(page).to have_content task_list[0].title
        expect(page).to have_content task_list[1].title
        expect(page).to have_content task_list[2].title
        expect(current_path).to eq tasks_path
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }
    describe 'タスク新規登録機能'
      context 'フォームの入力値が正常な時' do
        before do
          visit new_task_path
          fill_in 'Title', with: 'new_title'
          fill_in 'Content', with: 'new_content'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2099,12,31,11,59)
          click_button 'Create Task'
        end
        it 'タスクの新規登録が成功する' do
          expect(page).to have_content "Task was successfully created."
          expect(page).to have_content 'new_title'
          expect(page).to have_content 'new_content'
          expect(page).to have_content 'doing'
          expect(page).to have_content '2099/12/31 11:59'
        end
      end
    end

    describe 'タスク編集機能' do
      before { login(user) }
      context 'フォームの入力値が正常な時' do
        before do
          visit edit_task_path(task)
          fill_in 'Title', with: 'update_title'
          fill_in 'Content', with: 'update_content'
          find("option[value='todo']").select_option
          fill_in 'Deadline', with: '2099/12/31 11:59'
          click_button 'Update Task'
        end
        it 'タスクの編集が成功する' do
          expect(page).to have_content "Task was successfully updated."
          expect(page).to have_content 'update_title'
        end
      end
    end

    describe 'タスク削除機能' do
      let!(:task) { create(:task, user: user) }
      before { login(user) }
      context 'タスクの削除ボタンをクリックした時' do
        before do
          visit user_path(user)
          accept_alert do
            click_link 'Destroy'
          end
        end
        it 'タスクの削除が成功する' do
          expect(page).to have_content "Task was successfully destroyed."
          expect(current_path).to eq tasks_path
          expect(page).not_to have_content task.title
        end
      end
    end
    describe 'アクセス権限' do
      before { login(another_user) }
      context '他ユーザーのタスク編集ページへアクセスした時' do
        before do
          visit edit_task_path(user)
        end
        it 'タスク編集ページへのアクセスが失敗する' do
          expect(page).to have_content "Forbidden access."
        end
      end
    end
  end
end
