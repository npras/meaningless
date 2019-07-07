class Api::DiscussionsController < ApiController

  before_action :set_site
  before_action :set_discussion

  def show
    render json: { likes: discussion.likes }
  end

  def create
  end

  def likes_and_comments
    render json: { likes: @discussion.likes, comments: @discussion.comments }
  end

  def create_like
    @discussion.like!
    render json: { likes: @discussion.likes }
  end

  def create_comment
    user_ip = request.env['REMOTE_ADDR']
    user_agent = request.env['HTTP_USER_AGENT']
    referrer = request.env['HTTP_REFERER']
    name = params[:comment][:author_name]
    email = params[:comment][:email]
    body = params[:comment][:body]

    comment_info = {
      blog: @site.domain,
      user_ip: user_ip,
      user_agent: user_agent,
      referrer: referrer,
      comment_author: name,
      comment_author_email: email,
      comment_content: body,
    }

    comment = if SpamChecker.new(comment_info).spam?
                 nil
               else
                 @discussion.comments.create(
                   site: @site,
                   name: name,
                   email: email,
                   body: body,
                   ip_address: user_ip,
                   user_agent: user_agent,
                   referrer: referrer,
                 )
               end

    render json: { comment: comment }
  end

  private def set_site
    @site = Site.by_url(params[:url])
    if @site.nil?
      render json: { error: "Site has not been registered." }
    end
  end

  private def set_discussion
    @discussion = @site.discussions.by_url(params[:url])
  end

end
