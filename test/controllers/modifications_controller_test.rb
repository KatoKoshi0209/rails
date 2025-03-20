require "test_helper"

class ModificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get modifications_index_url
    assert_response :success
  end

  test "should get new" do
    get modifications_new_url
    assert_response :success
  end
end
