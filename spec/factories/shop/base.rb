FactoryBot.define do
  factory :shop do
    sequence(:name) { |n| "Store ##{n}" }
  end

  trait :with_products do
    transient do
      products do
        prod1 = create(:product, :with_category)
        prod2 = create(:product, :with_category)
        [prod1, prod2]
      end
    end

    after(:create) do |shop, evaluator|
      evaluator.products.each do |product|
        create(:shop_product, product_id: product.id, shop_id: shop.id)
      end
    end
  end
end
