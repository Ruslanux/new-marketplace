require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Create brand new records for the test to avoid conflicts with fixture data.
    @seller = User.create!(
      email_address: "seller-for-review-test@example.com",
      password: "password",
      role: :seller,
      first_name: "Test",
      last_name: "Seller"
    )
    @category = Category.create!(name: "Category for Review Test")
    @product = @seller.products.create!(
      name: "Product for Review Test",
      # FIXED: Added the missing 'description' attribute to satisfy the model validation.
      description: "A test description for our product.",
      price: 100,
      stock_quantity: 10,
      category: @category
    )
    @customer = User.create!(
      email_address: "customer-for-review-test@example.com",
      password: "password",
      role: :customer,
      first_name: "Test",
      last_name: "Customer"
    )

    sign_in(@customer)

    # Create the necessary purchase history for the new records.
    order = Order.create!(user: @customer, status: :shipped, total_amount: @product.price)
    OrderItem.create!(order: order, product: @product, quantity: 1, price: @product.price)
  end

  test "should create review" do
    assert_difference("Review.count") do
      post product_reviews_url(@product), params: {
        review: {
          rating: 5,
          comment: "This is a brand new review on a brand new product, so it should definitely save without any issues."
        }
      }
    end

    puts @response.body unless @response.redirect?

    assert_redirected_to product_url(@product)
  end
end
