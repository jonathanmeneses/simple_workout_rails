require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "destroy without login redirects" do
    delete session_url
    assert_redirected_to new_session_url
  end
end
