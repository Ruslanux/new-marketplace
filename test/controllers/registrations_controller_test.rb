require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sign_up_url # Corrected from registrations_new_url
    assert_response :success
  end

  test "should get create" do
    assert_difference("User.count") do
      post sign_up_url, params: { user: {
      first_name: "Test",
      last_name: "User",
      email_address: "test@example.com",
      password: "password",
      password_confirmation: "password"
    } }
    end
    assert_redirected_to root_url
  end
end
