FactoryBot.define do
  factory :user_shopping_list do
    shopping_list { create(:shopping_list) }
    user { create(:user) }
  end
end
