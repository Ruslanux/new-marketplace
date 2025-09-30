require "test_helper"

class Admin::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    sign_in(@admin)
    @product = products(:one)
  end

  test "should get index" do
    get admin_products_url
    assert_response :success
  end

  test "should get show" do
    get admin_product_url(@product)
    # The 'show' action should render a page successfully (200 OK).
    assert_response :success
  end

  test "should update product" do
    patch admin_product_url(@product), params: { product: { name: "New Name" } }
    assert_redirected_to admin_product_url(@product)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete admin_product_url(@product)
    end
    assert_redirected_to admin_products_url
  end
end
