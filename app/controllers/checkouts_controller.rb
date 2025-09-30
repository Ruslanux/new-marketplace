class CheckoutsController < ApplicationController
  def create
    cart_items = current_user.cart_items.includes(:product)

    if cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    # 1. Transform cart items into Stripe's line_items format
    line_items = cart_items.map do |item|
      {
        price_data: {
          currency: "usd", # Or your desired currency
          product_data: {
            name: item.product.name
          },
          unit_amount: (item.product.price * 100).to_i # Price in cents
        },
        quantity: item.quantity
      }
    end

    # 2. Create the Stripe Checkout Session
    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items: line_items,
      mode: "payment",
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: checkout_cancel_url,
      customer_email: current_user.email_address,
      # Store user_id in metadata to retrieve it in the webhook
      metadata: {
        user_id: current_user.id
      }
    )

    # 3. Redirect to Stripe's hosted payment page
    redirect_to session.url, allow_other_host: true, status: :see_other
  end

  def success
    # We will fulfill the order via webhook, so this page is just for the user.
    # You might want to show a component here.
    render plain: "Payment successful! Your order is being processed."
  end

  def cancel
    # Render a component to inform the user the payment was cancelled.
    render plain: "Payment was cancelled."
  end
end
