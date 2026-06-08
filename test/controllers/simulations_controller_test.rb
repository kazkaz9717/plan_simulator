require "test_helper"

class SimulationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get simulations_index_url
    assert_response :success
  end
end
