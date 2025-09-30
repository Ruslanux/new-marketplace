require "test_helper"

class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    sign_in(@admin)
    @order = orders(:one)
  end

  test "should get index" do
    get admin_orders_url
    assert_response :success
  end

  test "should get show" do
    get admin_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch admin_order_url(@order), params: { order: { status: "shipped" } }
    # After a successful update, the controller should REDIRECT to the show page.
    assert_redirected_to admin_order_url(@order)
  end
end
