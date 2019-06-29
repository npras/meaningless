require 'test_helper'

class EmbedControllerTest < ActionDispatch::IntegrationTest
  test "should get page_likes" do
    get embed_page_likes_url
    assert_response :success
  end

end
