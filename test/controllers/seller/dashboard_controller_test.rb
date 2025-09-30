require "test_helper"

class Seller::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seller = users(:seller)
    sign_in(@seller) # Assumes you have the sign_in helper and an :seller fixture
  end

  test "should get index" do
    get seller_root_url
    assert_response :success
  end
end
