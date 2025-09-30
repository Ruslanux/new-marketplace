require "test_helper"
require "tempfile" # Required for creating temporary files

class Seller::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seller = users(:seller)
    sign_in(@seller)
    @product = products(:one)
    @category = categories(:one)
  end

  test "should get index" do
    get seller_products_url
    assert_response :success
  end

  test "should get show" do
    get seller_product_url(@product)
    assert_response :success
  end

  test "should get new" do
    get new_seller_product_url
    assert_response :success
  end

  test "should create product" do
    temp_file = Tempfile.new([ "test_image", ".png" ])
    dummy_file = Rack::Test::UploadedFile.new(temp_file.path, "image/png")

    assert_difference("Product.count") do
      post seller_products_url, params: {
        product: {
          name: "New Camera",
          price: 499.99,
          description: "A high-quality camera for professional photos.",
          stock_quantity: 25,
          category_id: @category.id,
          images: [ dummy_file ]
        }
      }
    end

    temp_file.unlink

    assert_redirected_to seller_products_url
  end

  test "should get edit" do
    get edit_seller_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch seller_product_url(@product), params: { product: { name: "Updated Name" } }
    assert_redirected_to seller_product_url(@product)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete seller_product_url(@product)
    end
    assert_redirected_to seller_products_url
  end
end
