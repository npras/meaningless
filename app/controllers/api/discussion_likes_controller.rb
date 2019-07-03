class Api::DiscussionLikesController < ApiController

  def show
    discussion = @site.discussions.by_url(params[:url])
    render json: { likes: discussion.likes }
  end

  def create
    discussion = @site.discussions.by_url(params[:url])
    discussion.like!
    render json: { likes: discussion.likes }
  end

end
