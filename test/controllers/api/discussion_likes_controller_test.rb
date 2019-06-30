require 'test_helper'

class Api::DiscussionLikesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_discussion_likes_show_url
    assert_response :success
  end

  test "should get create" do
    get api_discussion_likes_create_url
    assert_response :success
  end

end
