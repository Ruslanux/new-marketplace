class ProductsController < ApplicationController
  # Allow public access to the index and show pages
  allow_unauthenticated_access only: [ :index, :show ]
  # Ensure only authorized users can manage products
  before_action :require_authentication, except: [ :index, :show ]
  before_action :set_product, only: [ :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  # GET /products
  def index
    @categories = Category.all
    @products = Product.includes(:user, :category, images_attachments: :blob).available

    if params[:category_id].present?
      @current_category = params[:category_id]
      @products = @products.by_category(@current_category)
    end

    if params[:search].present?
      @search_query = params[:search]
      @products = @products.search(@search_query)
    end

    @products = @products.page(params[:page]).per(12)

    render_component(Products::IndexComponent,
      products: @products,
      categories: @categories,
      current_category: @current_category,
      search_query: @search_query
    )
  end

  # GET /products/:id
  def show
    # ... (your existing show code)
    @product = Product.find(params[:id])
    @reviews = @product.reviews.includes(:user).order(created_at: :desc)

    @review = @product.reviews.new(user: current_user) if authenticated?

    render_component(Products::ShowComponent,
      product: @product,
      reviews: @reviews,
      review: @review
    )
  end

  # GET /products/new
  def new
    @product = current_user.products.new
  end

  # POST /products
  def create
    @product = current_user.products.new(product_params)
    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /products/:id/edit
  def edit
    # @product is set by the before_action
  end

  # PATCH/PUT /products/:id
  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def destroy
    @product.discard # Assuming you use the 'discard' gem for soft deletes
    redirect_to products_url, notice: "Product was successfully removed."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def authorize_user!
    # Users can only edit their own products, unless they are an admin
    unless @product.user == current_user || current_user.admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  # Strong parameters for product creation and updates
  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :category_id,
      :stock_quantity,
      images: [] # Allow multiple images
    )
  end
end
