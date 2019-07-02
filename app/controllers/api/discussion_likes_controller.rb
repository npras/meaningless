class Api::DiscussionLikesController < ApiController

  def show
    site = Site.by_url(params[:url])

    if site
      discussion = site.discussions.by_url(params[:url])
      render json: { likes: discussion.likes }
    else
      render json: { error: "Site has not been registered." }
    end
  end

  def create
    site = Site.by_url(params[:url])

    if site
      discussion = site.discussions.by_url(params[:url])
      discussion.like!
      render json: { likes: discussion.likes }
    else
      render json: { error: "Site has not been registered." }
    end
  end

end
