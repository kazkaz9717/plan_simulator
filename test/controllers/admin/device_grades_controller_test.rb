require "test_helper"

class Admin::DeviceGradesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_device_grades_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_device_grades_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_device_grades_edit_url
    assert_response :success
  end
end
