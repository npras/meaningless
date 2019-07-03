class Api::DiscussionCommentsController < ApiController

  before_action :set_discussion

  def index
    render json: { comments: @discussion.comments }
  end

  def create
    @discussion.comments.create(
      name: params[:comment][:name],
      email: params[:comment][:email],
      body: params[:comment][:body]
    )
  end

  private def set_discussion
    @discussion = @site.discussions.by_url(params[:url])
  end

end
