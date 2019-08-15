module PrasDevise
  class PrasDeviseController < ApplicationController

    private def load_recaptcha_secrets
      v2_creds = Rails.application.credentials.recaptcha[:v2]
      v3_creds = Rails.application.credentials.recaptcha[:v3]

      @v2_site_key, @v2_secret_key = v2_creds.values_at(:site_key, :secret_key)
      @v3_site_key, @v3_secret_key = v3_creds.values_at(:site_key, :secret_key)
    end

  end
end

