require 'test_helper'

class UserSignUpFlowsTest < ActionDispatch::IntegrationTest

  test "a new user is able to successfully signup for the site" do
    get '/registrations/new'
    assert_response :success

    post "/registrations", params: { user: valid_user_attributes }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div#notice', "Check your email with subject 'Confirmation instructions'"
  end

end
