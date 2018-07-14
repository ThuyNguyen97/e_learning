require 'test_helper'

class LessionLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get lession_logs_new_url
    assert_response :success
  end

end
