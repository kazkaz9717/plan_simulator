require "test_helper"

class Admin::DiscountsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_discounts_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_discounts_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_discounts_edit_url
    assert_response :success
  end
end
