class ReviewsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to product_path(@product), notice: "Review added successfully!"
    else
      # This provides detailed validation errors if the review fails to save.
      alert_message = "Could not add review: #{@review.errors.full_messages.join(', ')}"
      redirect_to product_path(@product), alert: alert_message
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
