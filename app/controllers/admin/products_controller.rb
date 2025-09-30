class Admin::ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.includes(:category, :user).page(params[:page]).per(20)
    render_component(Admin::Products::IndexComponent, products: @products)
  end

  def show
    render_component(Admin::Products::ShowComponent, product: @product)
  end

  def new
    @product = Product.new
    render_component(Admin::Products::FormComponent, product: @product)
  end

  def create
    @product = Product.new(product_params)
    # Assign the current admin as the seller for new products
    @product.user = current_user

    if @product.save
      redirect_to admin_product_path(@product), notice: "Product created successfully."
    else
      render_component(Admin::Products::FormComponent, product: @product)
    end
  end

  def edit
    render_component(Admin::Products::FormComponent, product: @product)
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Product updated successfully."
    else
      render_component(Admin::Products::FormComponent, product: @product)
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Product deleted successfully."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity, :category_id, :image)
  end
end
