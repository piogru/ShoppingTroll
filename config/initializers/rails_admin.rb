require "nested_form/engine"
require "nested_form/builder_mixin"

RailsAdmin.config do |config|
  ### Popular gems integration
  config.authorize_with do
    warden.authenticate! scope: :user
    redirect_to main_app.root_path unless current_user.admin == true
  end
  ## == Devise ==
  # config.authenticate_with do
  # warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  Rails.application.reloader.to_prepare do
    config.excluded_models = [
    ProductCategory,
    UserShoppingList
  ]
  end

  config.model "Product" do
    create do
      exclude_fields :shop_products, :shops
    end
    edit do
      exclude_fields :shops
    end
    import do
      include_all_fields
      exclude_fields :shops, :shop_products
      mapping_key :name
    end
  end

  config.model "Shop" do
    create do
      # exclude fields from "Add new" form since they cannot be linked to the shop before it's created
      exclude_fields :products, :shop_products, :reviews
    end
    edit do
      exclude_fields :products
    end
  end

  config.model "ShoppingList" do
    create do
      # exclude product fields from "Add new" form since they cannot be linked to the shopping list before it's created
      exclude_fields :shopping_list_shop_products, :shop_products
    end
    edit do
      exclude_fields :shop_products
    end
  end

  config.model "ShopProduct" do
    create do
      exclude_fields :shopping_lists, :shopping_list_shop_products
    end
    edit do
      exclude_fields :shopping_lists
    end
    import do
      mapping_key [:shop_id, :product_id]
    end
  end

  config.model "User" do
    create do
      exclude_fields :reviews, :shopping_lists, :reset_password_sent_at, :remember_created_at
    end
  end
end
