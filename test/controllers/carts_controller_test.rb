require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer = users(:customer)
    @cart_item = cart_items(:one)
    sign_in(@customer)
  end

  test "should show cart" do
    get cart_url
    assert_response :success
  end

  test "should update cart item" do
    patch cart_url, params: { cart_item_id: @cart_item.id, quantity: 3 }
    # FIXED: The controller redirects after an update, so the test should expect a redirect.
    assert_redirected_to cart_url

    # Optional: Check if the quantity was actually updated
    assert_equal 3, @cart_item.reload.quantity
  end

  test "should destroy cart item" do
    # The remove action in your controller uses product_id
    assert_difference("CartItem.count", -1) do
      delete remove_from_cart_url(product_id: @cart_item.product_id)
    end

    assert_redirected_to cart_path
  end
end
