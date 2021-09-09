Rails.application.routes.draw do
  root to: "pages#index"
  devise_for :users
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  resources :shops, only: %i(index show) do
    resources :reviews
  end
  resources :categories, only: %w(index show)
  resources :products, only: %w(index show)
  resources :shopping_list_shop_products, only: %i(edit update destroy)
  resources :shopping_lists do
    resources :shopping_list_shop_products, only: %i(update)
    member do
      post :share
      delete :remove_user
      delete :remove_self
    end
  end
  get "/shop_products/:id/add_to_shopping_list", to: "shopping_list_shop_products#new",
                                                 as: "add_to_shopping_list"
  post "/shop_products/:id/add_to_shopping_list", to: "shopping_list_shop_products#create",
                                                  as: "create_shopping_list_shop_product"
  get "calculate_capacity", to: "capacity#calculate_capacity"
  get "calculate_form", to: "capacity#calculate_form"

  get "import-recipe/:id", to: "recipes#import_form",
                           as: "recipe_import_form"
  post "import-recipe", to: "recipes#import",
                        as: "recipe_import"
end
