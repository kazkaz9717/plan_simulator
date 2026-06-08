require "test_helper"

class Admin::MakersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_makers_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_makers_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_makers_edit_url
    assert_response :success
  end
end
