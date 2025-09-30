class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [ :show, :edit, :update, :destroy, :restore ]

  def index
    @categories = Category.page(params[:page]).per(20)
    render_component(Admin::Categories::IndexComponent, categories: @categories)
  end

  def discarded
    # This is the key fix: .unscoped tells Rails to find all categories,
    # including the archived ones.
    @categories = Category.unscoped.discarded.page(params[:page]).per(20)
    render_component(Admin::Categories::DiscardedComponent, categories: @categories)
  end

  def new
    @category = Category.new
    render_component(Admin::Categories::FormComponent, category: @category)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category created successfully."
    else
      render_component(Admin::Categories::FormComponent, category: @category)
    end
  end

  def edit
    render_component(Admin::Categories::FormComponent, category: @category)
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category updated successfully."
    else
      render_component(Admin::Categories::FormComponent, category: @category)
    end
  end

  def destroy
    @category.discard
    redirect_to admin_categories_path, notice: "Category archived successfully."
  end

  def restore
    @category.undiscard
    redirect_to discarded_admin_categories_path, notice: "Category restored successfully."
  end

  private

  def set_category
    @category = Category.unscoped.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
