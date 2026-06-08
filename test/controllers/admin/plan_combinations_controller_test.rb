require "test_helper"

class Admin::PlanCombinationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_plan_combinations_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_plan_combinations_new_url
    assert_response :success
  end
end
