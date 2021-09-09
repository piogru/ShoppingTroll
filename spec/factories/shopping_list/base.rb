FactoryBot.define do
  factory :shopping_list do
    name { "Weekly groceries" }
    owner { create(:user, email: "owner@gmail.com", nickname: "owner") }

    trait :with_users do
      transient do
        users { [] }
      end

      after :create do |shopping_list, evaluator|
        evaluator.users.each do |user|
          create(:user_shopping_list, user: user, shopping_list: shopping_list)
        end
      end
    end

    trait :with_shop_products do
      transient do
        shop_products { [] }
      end

      after :create do |shopping_list, evaluator|
        evaluator.shop_products.each do |shop_product|
          create(:shopping_list_shop_product,
                 shop_product:  shop_product,
                 shopping_list: shopping_list)
        end
      end
    end
  end
end
