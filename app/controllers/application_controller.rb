class ApplicationController < ActionController::Base

  private def load_recaptcha_secrets
    v2_creds = Rails.application.credentials.recaptcha[:v2]
    @v2_site_key, @v2_secret_key = v2_creds.values_at(:site_key, :secret_key)
  end

  private def check_captcha(render_on_fail: :new)
    recaptcha_success_v2 = verify_recaptcha(site_key: @v2_site_key,
                                            secret_key: @v2_secret_key)
    render render_on_fail and return unless recaptcha_success_v2
  end

  # PrasDevise Helpers
  #
  private def current_user
    @_current_user ||= (
      if cookies.encrypted[:remember_token]
        User.find_by(remember_token: cookies.encrypted[:remember_token])
    else
      nil
    end
    )
  end
  helper_method :current_user

  private def authenticate_user!
    redirect_to new_session_path, alert: "Not authorized!" if current_user.nil?
  end

end
