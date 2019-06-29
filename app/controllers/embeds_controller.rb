class EmbedsController < ApplicationController

  include ActionView::Helpers::AssetUrlHelper
  include Webpacker::Helper

  protect_from_forgery except: :page_likes

  def page_likes
    respond_to do |format|
      format.js { redirect_to sources_from_manifest_entries(['pageLikes'], type: :javascript).first }
      #format.css
    end
  end

end
