class WebhooksController < ApplicationController
  # Allow unauthenticated access for Stripe's webhook
  allow_unauthenticated_access

  # Disable CSRF protection for this endpoint
  skip_forgery_protection

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.stripe[:webhook_secret]
    event = nil

    # 1. Verify the event is genuinely from Stripe
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { error: "Invalid payload" }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: "Invalid signature" }, status: 400
      return
    end

    # 2. Handle the 'checkout.session.completed' event
    case event.type
    when "checkout.session.completed"
      session = event.data.object # contains a Stripe::Checkout::Session
      fulfill_order(session)
    else
      # You can ignore other event types for now
      puts "Unhandled event type: #{event.type}"
    end

    render json: { message: :success }, status: 200
  end

  private

  def fulfill_order(session)
    user = User.find(session.metadata.user_id)
    cart_items = user.cart_items.includes(:product)

    # Use a transaction to ensure all database operations succeed or none do.
    ApplicationRecord.transaction do
      order = user.orders.create!(
        total_amount: session.amount_total / 100.0,
        status: :paid,
        stripe_payment_intent_id: session.payment_intent
      )

      cart_items.each do |cart_item|
        # Check if there is enough stock BEFORE trying to create the order item
        unless cart_item.product.stock_quantity >= cart_item.quantity
          # This will stop the transaction and raise an error that our rescue block will catch
          raise "Not enough stock for #{cart_item.product.name}"
        end

        order.order_items.create!(
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.price,
          total_price: cart_item.total_price # Assumes OrderItem has this attribute from your previous code
        )
        cart_item.product.reduce_stock!(cart_item.quantity)
      end

      # Clear the user's cart only after everything else succeeds
      user.cart_items.destroy_all
    end
  rescue => e
    # Log the error for debugging and prevent the 500 error
    Rails.logger.error "Webhook fulfillment failed: #{e.message}"
    # You might want to send an email to yourself here to alert you of the failure
  end
end
