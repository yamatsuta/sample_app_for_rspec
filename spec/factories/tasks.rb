FactoryBot.define do
  factory :task do
    title {'タスクのタイトル'}
    content {'タスクのコンテンツ'}
    status {0}
    deadline {'2022-01-01'}
    user
  end
end
