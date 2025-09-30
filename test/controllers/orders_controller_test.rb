require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer = users(:customer) # Requires a 'customer' user in users.yml
    sign_in(@customer)
    @order = orders(:one)
  end

  test "should get index" do
    get orders_url # Corrected from orders_index_url
    assert_response :success
  end

  test "should get show" do
    get order_url(@order) # Corrected from orders_show_url
    assert_response :success
  end

  # The create test requires items in the cart first, which is more complex.
  # You can start with the index and show tests.
end
