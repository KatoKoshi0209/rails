require "test_helper"

class Administrator::ShiftRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get administrator_shift_requests_index_url
    assert_response :success
  end
end
