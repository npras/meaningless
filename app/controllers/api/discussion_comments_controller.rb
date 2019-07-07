class Api::DiscussionCommentsController < ApiController

  before_action :set_discussion

  def index
    @comments = @discussion.comments
  end

  def create
  end

  private def set_discussion
    @discussion = @site.discussions.by_url(params[:url])
  end

end
