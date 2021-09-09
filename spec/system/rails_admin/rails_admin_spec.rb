require "rails_helper"

RSpec.describe "rails_admin", type: :system, js: true do
  let!(:admin) { create(:user, email: "admin@example.com", admin: true) }

  before do
    driven_by :chrome_headless

    sign_in admin
  end

  describe "Product import" do
    before do
      visit rails_admin.import_path("Product")
    end

    context "given products" do
      before do
        page.attach_file("file", Rails.root + "spec/system/rails_admin/import/products.csv")
      end

      it "adds specified products" do
        click_button "Save"

        product_1 = Product.find_by_name("Import#1").attributes.except("id", "created_at", "updated_at")
        product_2 = Product.find_by_name("Import#2").attributes.except("id", "created_at", "updated_at")
        product_params_1 = { "name" => "Import#1", "capacity" => 1000, "label" => "ml", "ml_to_g_rate" => 2.0 }
        product_params_2 = { "name" => "Import#2", "capacity" => 2000, "label" => "g", "ml_to_g_rate" => 3.0 }

        expect(page).to have_css(".alert-success", text: "2 Products successfully Imported")

        expect(product_1).to eq(product_params_1)
        expect(product_2).to eq(product_params_2)
      end
    end

    context "given invalid file" do
      before do
        page.attach_file("file", Rails.root + "spec/system/rails_admin/import/shops.csv")
      end

      it "adds specified products" do
        click_button "Save"
        expect(page).to have_css(".alert-danger", text: "2 Products failed to be Imported")
      end
    end

  end

  describe "Shop import" do
    before do
      visit rails_admin.import_path("Shop")
    end

    context "given shop names" do
      before do
        page.attach_file("file", Rails.root + "spec/system/rails_admin/import/shops.csv")
      end

      it "adds specified shops" do
        click_button "Save"

        shop_1 = Shop.find_by_name("Shop#1").attributes.except("id", "created_at", "updated_at")
        shop_2 = Shop.find_by_name("Shop#2").attributes.except("id", "created_at", "updated_at")
        params_1 = { "name"=>"Shop#1" }
        params_2 = { "name"=>"Shop#2" }

        expect(page).to have_css(".alert-success", text: "2 Shops successfully Imported")

        expect(shop_1).to eq(params_1)
        expect(shop_2).to eq(params_2)
      end
    end
  end

  describe "ShopProduct import" do
    let!(:shop_1) { create(:shop, name: "Shop#1") }
    let!(:shop_2) { create(:shop, name: "Shop#2") }
    let!(:product_1) { create(:product, name: "Import#1", capacity: 1000, label: "ml", ml_to_g_rate: 2.0) }
    let!(:product_2) { create(:product, name: "Import#2", capacity: 2000, label: "g", ml_to_g_rate: 3.0) }

    before do
      visit rails_admin.import_path("ShopProduct")
    end

    context "given shop products" do
      before do
        page.attach_file("file", Rails.root + "spec/system/rails_admin/import/shop_products.csv")
      end

      it "adds specified shop products" do
        click_button "Save"

        shop_product_1 = ShopProduct.find_by(shop: shop_1, product: product_1)
        shop_product_2 = ShopProduct.find_by(shop: shop_1, product: product_2)
        shop_product_3 = ShopProduct.find_by(shop: shop_2, product: product_1)
        shop_product_4 = ShopProduct.find_by(shop: shop_2, product: product_2)
        shop_product_params_1 = { "price" => 100.1, "shop_id" => shop_1.id, "product_id" => product_1.id }
        shop_product_params_2 = { "price" => 100.2, "shop_id" => shop_1.id, "product_id" => product_2.id }
        shop_product_params_3 = { "price" => 200.1, "shop_id" => shop_2.id, "product_id" => product_1.id }
        shop_product_params_4 = { "price" => 200.2, "shop_id" => shop_2.id, "product_id" => product_2.id }

        expect(page).to have_css(".alert-success", text: "4 Shop products successfully Imported")

        expect(shop_product_1.attributes.except("id", "created_at", "updated_at")).to eq(shop_product_params_1)
        expect(shop_product_2.attributes.except("id", "created_at", "updated_at")).to eq(shop_product_params_2)
        expect(shop_product_3.attributes.except("id", "created_at", "updated_at")).to eq(shop_product_params_3)
        expect(shop_product_4.attributes.except("id", "created_at", "updated_at")).to eq(shop_product_params_4)
      end
    end
  end

end
