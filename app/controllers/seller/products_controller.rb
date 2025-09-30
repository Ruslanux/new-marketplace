class Seller::ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy, :restore ]

  def index
    @products = current_user.products.includes(:category).page(params[:page]).per(10)
    render_component(Seller::Products::IndexComponent, products: @products)
  end

  def discarded
    @products = current_user.products.unscoped.discarded.includes(:category).page(params[:page]).per(10)
    render_component(Seller::Products::DiscardedComponent, products: @products)
  end

  def show
    render_component(Seller::Products::ShowComponent, product: @product)
  end

  def new
    @product = current_user.products.build
    @categories = Category.all
    render_component(Seller::Products::FormComponent, product: @product, categories: @categories)
  end

  def create
    @product = current_user.products.build(product_params)
    @categories = Category.all

    if @product.save
      redirect_to seller_products_path, notice: "Product created successfully!"
    else
      render_component(Seller::Products::FormComponent, product: @product, categories: @categories)
    end
  end

  def edit
    @categories = Category.all
    render_component(Seller::Products::FormComponent, product: @product, categories: @categories)
  end

  def update
    @categories = Category.all

    if @product.update(product_params)
      redirect_to seller_product_path(@product), notice: "Product updated successfully!"
    else
      render_component(Seller::Products::FormComponent, product: @product, categories: @categories)
    end
  end

  def destroy
    @product.discard
    redirect_to seller_products_path, notice: "Product was successfully archived."
  end

  def restore
    @product.undiscard
    redirect_to seller_products_path, notice: "Product was successfully restored."
  end

  private

  def set_product
    @product = current_user.products.unscoped.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity, :category_id, :image)
  end
end
