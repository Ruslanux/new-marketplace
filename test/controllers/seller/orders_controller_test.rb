require "test_helper"

class Seller::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seller = users(:seller)
    sign_in(@seller)
    @order = orders(:one)
  end

  test "should get index" do
    get seller_orders_url
    assert_response :success
  end

  test "should get show" do
    get seller_order_url(@order)
    # The 'show' action should render a page successfully (200 OK).
    assert_response :success
  end

  test "should update order" do
    patch seller_order_url(@order), params: { order: { status: "shipped" } }
    # After a successful update, the controller should REDIRECT to the show page.
    assert_redirected_to seller_order_url(@order)
  end
end
