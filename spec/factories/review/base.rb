FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "Review ##{n}" }
    description { "Lorem ipsum dolor sit amet" }
    stars { 5 }
  end
end
