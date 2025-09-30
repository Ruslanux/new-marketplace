class CartsController < ApplicationController
  # Authentication is handled by the ApplicationController.

  def show
    @cart_items = current_user.cart_items.includes(product: [ :user, { images_attachments: :blob } ])
    render_component(Carts::ShowComponent, cart_items: @cart_items)
  end

  def add
    @product = Product.find(params[:product_id])
    @cart_item = current_user.cart_items.find_or_initialize_by(product: @product)
    @cart_item.quantity = (@cart_item.quantity || 0) + 1

    if @cart_item.save
    # This block will now handle Turbo Stream and regular HTML requests
    respond_to do |format|
      format.turbo_stream do
        # We will create a new file to render the stream response
        flash.now[:notice] = "#{@product.name} was added to your cart."
      end
      format.html { redirect_to cart_path, notice: "#{@product.name} was added to your cart." }
      end
    else
      # Improved alert message for easier debugging.
      alert_message = "Could not add item to cart: #{@cart_item.errors.full_messages.join(', ')}"
      redirect_back(fallback_location: root_path, alert: alert_message)
    end
  end

  def remove
    @cart_item = current_user.cart_items.find_by(product_id: params[:product_id])
    @cart_item&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path, notice: "Item removed from cart." }
    end
  end

  def update
    @cart_item = current_user.cart_items.find(params[:cart_item_id])
    new_quantity = params[:quantity].to_i

    if new_quantity <= 0
      @cart_item.destroy
      flash.now[:notice] = "Item removed from cart."
    elsif @cart_item.update(quantity: new_quantity)
      flash.now[:notice] = "Cart updated."
    else
      flash.now[:alert] = "Could not update cart."
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path }
    end
  end
end
