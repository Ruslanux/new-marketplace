class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.includes(:order_items, :products).page(params[:page]).per(10)
    render_component(Orders::IndexComponent, orders: @orders)
  end

  def show
    @order = current_user.orders.find(params[:id])
    render_component(Orders::ShowComponent, order: @order)
  end

  def create
    @cart_items = current_user.cart_items.includes(:product)

    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty"
      return
    end

    @order = current_user.orders.build(
      total_amount: current_user.cart_total,
      status: :pending
    )

    if @order.save
      @cart_items.each do |cart_item|
        @order.order_items.create!(
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.price,
          total_price: cart_item.total_price
        )
        cart_item.product.reduce_stock!(cart_item.quantity)
      end

      current_user.cart_items.destroy_all
      redirect_to order_path(@order), notice: "Order placed successfully!"
    else
      redirect_to cart_path, alert: "Could not place order"
    end
  end
end
