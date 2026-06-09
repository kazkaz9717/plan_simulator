require "test_helper"

class Admin::DevicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_devices_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_devices_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_devices_edit_url
    assert_response :success
  end
end
