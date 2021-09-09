return unless Rails.env.development? || Rails.env.test?
  Rails.logger = Logger.new($stdout)
  Rails.logger.info "Creating users..."
  User.create!(
    email:                 "admin@test.com",
    nickname:              "nickname",
    password:              "password",
    password_confirmation: "password",
    admin:                 true
  )
  Rails.logger.info "Admin user created"
  User.create!(
    email:                 "user@test.com",
    nickname:              "nickname1",
    password:              "password",
    password_confirmation: "password",
    admin:                 false
  )
  Rails.logger.info "User created"
  Rails.logger.info "Creating categories..."
  Category.create!([
    { name: "vegetables" },
    { name: "fruits" },
    { name: "dairy" },
    { name: "bakery" },
    { name: "alcohol" },
    { name: "meat" },
    { name: "sweets" },
    { name: "soft drinks" },
    { name: "fish" },
    { name: "household" },
  ])
  Rails.logger.info "Categories created..."
  Rails.logger.info "Creating shops..."
  Shop.create!([
    { name: "Alkohole Świata" },
    { name: "Tesco" },
    { name: "Auchan" },
    { name: "Kaufland" },
    { name: "Waitrose" },
    { name: "Lidl" },
    { name: "Makro" },
    { name: "Netto" },
    { name: "Biedronka" },
  ])
  Rails.logger.info "Shops created..."
  Rails.logger.info "Creating products..."
  Product.create!([
    { name: "milk", capacity: 1500, label: "ml", categories: Category.all.sample(1), ml_to_g_rate: 1 },
    { name: "water", capacity: 1500, label: "ml", categories: Category.all.sample(1), ml_to_g_rate: 1 },
    { name: "beer", capacity: 500, label: "ml", categories: Category.all.sample(1), ml_to_g_rate: 1 },
    { name: "coke", capacity: 1500, label: "ml", categories: Category.all.sample(1), ml_to_g_rate: 1 },
    { name: "orange", capacity: 1, label: "kg", categories: Category.all.sample(1), ml_to_g_rate: 1 },
    { name: "apple", capacity: 1, label: "kg", categories: Category.all.sample(1), ml_to_g_rate: 1 },
    { name: "salmon", capacity: 1, label: "kg", categories: Category.all.sample(1), ml_to_g_rate: 1 },
    { name: "sugar", capacity: 1, label: "kg", categories: Category.all.sample(1), ml_to_g_rate: 1 },
  ])
  Rails.logger.info "Products created..."
  Rails.logger.info "Creating shop products..."
  ShopProduct.create!([
    { product_id: 1, shop_id: 1, price: (10.0).to_d },
    { product_id: 2, shop_id: 2, price: (10.0).to_d },
    { product_id: 3, shop_id: 3, price: (10.0).to_d },
    { product_id: 4, shop_id: 4, price: (10.0).to_d },
    { product_id: 5, shop_id: 5, price: (10.0).to_d },
    { product_id: 6, shop_id: 6, price: (10.0).to_d },
    { product_id: 7, shop_id: 7, price: (10.0).to_d },
    { product_id: 8, shop_id: 8, price: (10.0).to_d },
  ])
  Rails.logger.info "Shop products created..."
  Rails.logger.info "Creating shopping lists..."
  ShoppingList.create!([
    { name: "Family shopping", owner_id: 1 },
    { name: "Things to buy", owner_id: 2 },
  ])
  Rails.logger.info "Shopping lists  created..."
  Rails.logger.info "Creating shopping lists users..."
  UserShoppingList.create!([
    { shopping_list_id: 2, user_id: 1 },
  ])
  Rails.logger.info "Shopping lists users created..."
  Rails.logger.info "Creating shopping lists shop products..."
  ShoppingListShopProduct.create!([
    { shopping_list_id: 1, bought: false, shop_product_id: 2, amount: 1 },
    { shopping_list_id: 1, bought: false, shop_product_id: 3, amount: 3 },
    { shopping_list_id: 2, bought: false, shop_product_id: 5, amount: 2 },
  ])
  Rails.logger.info "Shopping lists shop products created..."
  Rails.logger.info "Creating shop reviews..."
  Review.create!([
    { title: "Lovely shop", description: "Love buying products here", stars: 5, shop_id: 1, user_id: 1 },
  ])
  Rails.logger.info "Shop reviews created..."
