require 'test_helper'

class Api::DiscussionCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_discussion_comments_index_url
    assert_response :success
  end

  test "should get create" do
    get api_discussion_comments_create_url
    assert_response :success
  end

end
