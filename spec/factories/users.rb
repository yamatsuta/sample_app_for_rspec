FactoryBot.define do
  factory :user do
    email {'a@example.com'}
    password {'password'}
    password_confirmation {'password'}
  end
end
