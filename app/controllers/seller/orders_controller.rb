class Seller::OrdersController < ApplicationController
  before_action :set_order_item, only: [ :show, :update ]

  def index
    @order_items = OrderItem.joins(:product, :order)
                           .where(products: { user_id: current_user.id })
                           .includes(:order, :product)
                           .page(params[:page]).per(20)

    render(Seller::Orders::IndexComponent.new(order_items: @order_items))
  end

  def show
    # FIXED: The component was expecting a keyword argument of 'order:', but was receiving 'order_item:'.
    # This now passes the associated order from the order_item, resolving the ArgumentError.
    render(Seller::Orders::ShowComponent.new(order: @order_item.order))
  end

  def update
    if @order_item.order.update(status: params[:status])
      redirect_to seller_order_path(@order_item), notice: "Order status updated"
    else
      redirect_to seller_order_path(@order_item), alert: "Could not update order"
    end
  end

  private

  def set_order_item
    @order_item = OrderItem.joins(:product)
                          .where(products: { user_id: current_user.id })
                          .includes(:order, :product)
                          .find(params[:id])
  end
end
