class Api::DiscussionCommentsController < ApiController

  before_action :set_discussion

  def index
    @comments = @discussion.comments
  end

  def create
    @comment = @discussion.comments.create(
      name: params[:comment][:author_name],
      email: params[:comment][:email],
      body: params[:comment][:body],
      site: @site,
    )
  end

  private def set_discussion
    @discussion = @site.discussions.by_url(params[:url])
  end

end
