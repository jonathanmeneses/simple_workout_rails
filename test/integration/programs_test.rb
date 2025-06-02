require "test_helper"

class ProgramsTest < ActionDispatch::IntegrationTest
  test "GET /programs/index returns http success" do
    get "/programs/index"
    assert_response :success
  end
end
