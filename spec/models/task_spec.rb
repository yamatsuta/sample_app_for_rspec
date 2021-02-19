require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    #全テストで使うユーザーを作成する
    let!(:user) { FactoryBot.create(:user) }

    it 'title,statusがあれば有効であること' do
      task = FactoryBot.create(:task, title: 'タスクのタイトル', status: 0, user: user)
      expect(task).to be_valid
    end

    it 'titleがなければ無効であること' do
      task = FactoryBot.build(:task, title: nil, status: 0, user: user)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'statusがなければ無効であること' do
      task = FactoryBot.build(:task, title: 'タスクのタイトル', status: nil, user: user)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it '同じ名称のtitleは無効であること' do
      task_a = FactoryBot.create(:task, title: 'タスクのタイトル', user: user)
      task_b = FactoryBot.build(:task, title: 'タスクのタイトル', user: user)
      task_b.valid?
      expect(task_b.errors[:title]).to include("has already been taken")
    end

    it '異なる名称のtitleは有効であること' do
      task_a = FactoryBot.create(:task, title: 'タスクのタイトルa', user: user)
      task_b = FactoryBot.build(:task, title: 'タスクのタイトルb', user: user)
      expect(task_b).to be_valid
    end
  end
end
