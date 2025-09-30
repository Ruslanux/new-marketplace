require "test_helper"

class CheckoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer = users(:customer) # From your users.yml fixture
    sign_in(@customer)
  end

  test "should get create" do
    # Use POST to the correct resourceful route
    post checkout_url
    assert_response :redirect # It should redirect to Stripe
  end
end
