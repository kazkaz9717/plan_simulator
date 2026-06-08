require "test_helper"

class Admin::PlanCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_plan_categories_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_plan_categories_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_plan_categories_edit_url
    assert_response :success
  end
end
