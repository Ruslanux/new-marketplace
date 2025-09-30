class Admin::OrdersController < ApplicationController
  before_action :set_order, only: [ :show, :update ]

  def index
    @orders = Order.includes(:user).page(params[:page]).per(20)
    render_component(Admin::Orders::IndexComponent, orders: @orders)
  end

  def show
    render_component(Admin::Orders::ShowComponent, order: @order)
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "Order status updated."
    else
      render_component(Admin::Orders::ShowComponent, order: @order)
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
