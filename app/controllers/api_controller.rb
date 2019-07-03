class ApiController < ActionController::API

  before_action :set_site

  private def set_site
    @site = Site.by_url(params[:url])
    if @site.nil?
      render json: { error: "Site has not been registered." }
    end
  end

end
