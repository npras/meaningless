require 'test_helper'

class UserSignUpFlowsTest < ActionDispatch::IntegrationTest

  test "a new user is able to successfully signup for the site" do
    user = valid_user_attributes

    # 1. user visits the signup page and submits the form
    get '/registrations/new'
    assert_response :success
    assert_emails 1 do
      post "/registrations", params: { user: user }
    end
    assert_and_follow_redirect!
    assert_response :success
    assert_select 'div#notice', "Check your email with subject 'Confirmation instructions'"

    # 2. user attempts to login without confirming
    post '/sessions', params: { email: user[:email], password: user[:password] }
    assert_response :success
    assert_select 'div#alert', "Email or password is invalid"

    # 3. user gets email and clicks the confirmation link
    db_user = User.find_by(email: user[:email])
    get "/confirmations/#{db_user.id}?confirmation_token=#{db_user.confirmation_token}"
    assert_and_follow_redirect!
    assert_response :success
    assert_select 'div#notice', "You are confirmed! You can now login."

    # 4. user can login now
    post '/sessions', params: { email: user[:email], password: user[:password] }
    assert_and_follow_redirect!
    assert_select 'div#notice', "Logged in!"
  end

end
