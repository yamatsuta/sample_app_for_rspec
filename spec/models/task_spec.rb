require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    #全テストで使うユーザーを作成する

    it 'title,statusがあれば有効であること' do
      task = create(:task)
      expect(task).to be_valid
    end

    it 'titleがなければ無効であること' do
      task_without_title = build(:task, title: nil)
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end

    it 'statusがなければ無効であること' do
      task_without_status = build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end

    it '同じ名称のtitleは無効であること' do
      task = create(:task)
      task_with_duplicated_title = build(:task, title: task.title)
      expect(task_with_duplicated_title).to be_invalid
      expect(task_with_duplicated_title.errors[:title]).to include("has already been taken")
    end

    it '異なる名称のtitleは有効であること' do
      task_1 = create(:task)
      task_2 = build(:task)
      expect(task_2).to be_valid
    end
  end
end
