FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product ##{n}" }
    capacity { 500 }
    label { "ml" }
    ml_to_g_rate { 1.04 }
  end

  trait :with_category do
    after(:create) do |product|
      create(:category, product_ids: product.id)
    end
  end
end
