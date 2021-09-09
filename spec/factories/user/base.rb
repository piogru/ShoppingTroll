FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    sequence(:nickname) { |n| "user#{n}" }
  end
end
