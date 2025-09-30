require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin) # Requires an 'admin' user in users.yml
    sign_in(@admin)
    @user = users(:one)
  end

  test "should get index" do
    get admin_users_url
    assert_response :success
  end

  test "should get show" do
    get admin_user_url(@user)
    assert_response :success
  end

  test "should get update" do
    patch admin_user_url(@user), params: { user: { role: "seller" } }
    assert_redirected_to admin_user_url(@user)
  end

  test "should get destroy" do
    assert_difference("User.count", -1) do
      delete admin_user_url(@user)
    end
    assert_redirected_to admin_users_url
  end
end
