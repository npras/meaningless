class Api::DiscussionLikesController < ApiController

  before_action :set_site

  def show
    discussion = @site.discussions.by_url(params[:url])
    render json: { likes: discussion.likes }
  end

  def create
    discussion = @site.discussions.by_url(params[:url])
    discussion.like!
    render json: { likes: discussion.likes }
  end

  private def set_site
    @site = Site.by_url(params[:url])
    if @site.nil?
      render json: { error: "Site has not been registered." }
    end
  end

end
