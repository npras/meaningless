module PrasDevise
  class PrasDeviseController < ApplicationController

    def require_no_authentication
      if cookies[:remember_token]
        redirect_to root_url, alert: "Already authenticated!"
      end
    end

  end
end

