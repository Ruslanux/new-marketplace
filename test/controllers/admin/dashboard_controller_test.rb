require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    sign_in(@admin) # Assumes you have the sign_in helper and an :admin fixture
  end

  test "should get index" do
    get admin_root_url
    assert_response :success
  end
end
