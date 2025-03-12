require "test_helper"

class Administrator::ShiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get administrator_shifts_new_url
    assert_response :success
  end

  test "should get create" do
    get administrator_shifts_create_url
    assert_response :success
  end

  test "should get index" do
    get administrator_shifts_index_url
    assert_response :success
  end
end
