require "test_helper"

class Admin::SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_subscriptions_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_subscriptions_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_subscriptions_edit_url
    assert_response :success
  end
end
