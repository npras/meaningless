class EmbedsController < ApplicationController

  include ActionView::Helpers::AssetUrlHelper
  include Webpacker::Helper

  protect_from_forgery except: :page_likes_and_comments

  def page_likes_and_comments
    respond_to do |format|
      format.js do
        redirect_to(sources_from_manifest_entries(['pageLikesAndComments'],
                                                  type: :javascript).first)
      end
      #format.css
    end
  end

end
