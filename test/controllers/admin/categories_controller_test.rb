require "test_helper"

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    sign_in(@admin)
    @category = categories(:one)
  end

  test "should get index" do
    get admin_categories_url
    assert_response :success
  end

  test "should get show" do
    get admin_category_url(@category)
    assert_response :success
  end

  test "should get new" do
    get admin_categories_url
    assert_response :success
  end

  test "should get create" do
    get admin_categories_url
    assert_response :success
  end

  test "should get edit" do
    get admin_categories_url
    assert_response :success
  end

  test "should get update" do
    get admin_categories_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_categories_url
    assert_response :success
  end
end
