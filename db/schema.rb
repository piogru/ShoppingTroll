# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_26_183414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "product_categories", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "capacity", precision: 10, scale: 2, null: false
    t.string "label", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "ml_to_g_rate", precision: 6, scale: 4, default: "1.0", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "stars"
    t.integer "shop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.index ["shop_id"], name: "index_reviews_on_shop_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "shop_products", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "price", precision: 10, scale: 2
    t.index ["product_id"], name: "index_shop_products_on_product_id"
    t.index ["shop_id"], name: "index_shop_products_on_shop_id"
  end

  create_table "shopping_list_shop_products", force: :cascade do |t|
    t.boolean "bought", default: false
    t.integer "amount"
    t.integer "shopping_list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "shop_product_id", null: false
    t.index ["shop_product_id"], name: "index_shopping_list_shop_products_on_shop_product_id"
    t.index ["shopping_list_id"], name: "index_shopping_list_shop_products_on_shopping_list_id"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "owner_id", null: false
    t.index ["owner_id"], name: "index_shopping_lists_on_owner_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_shops_on_name", unique: true
  end

  create_table "user_shopping_lists", force: :cascade do |t|
    t.integer "shopping_list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.index ["shopping_list_id"], name: "index_user_shopping_lists_on_shopping_list_id"
    t.index ["user_id"], name: "index_user_shopping_lists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nickname", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "product_categories", "categories", on_delete: :cascade
  add_foreign_key "product_categories", "products", on_delete: :cascade
  add_foreign_key "reviews", "shops", on_delete: :cascade
  add_foreign_key "reviews", "users", on_delete: :cascade
  add_foreign_key "shop_products", "products", on_delete: :cascade
  add_foreign_key "shop_products", "shops", on_delete: :cascade
  add_foreign_key "shopping_list_shop_products", "shop_products", on_delete: :cascade
  add_foreign_key "shopping_list_shop_products", "shopping_lists", on_delete: :cascade
  add_foreign_key "shopping_lists", "users", column: "owner_id", on_delete: :cascade
  add_foreign_key "user_shopping_lists", "shopping_lists", on_delete: :cascade
  add_foreign_key "user_shopping_lists", "users", on_delete: :cascade
end
