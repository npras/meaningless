module PrasDevise
  class PasswordResetsController < PrasDeviseController

    prepend_before_action :require_no_authentication
    before_action :load_recaptcha_secrets

    def new
    end

    def create
      check_captcha; return if performed?
      user = User.find_by(email: params[:email])
      user&.send_password_reset!

      redirect_to root_url, notice: "If you had registered, you'd receive password reset email shortly"
    end

    def edit
      set_user
    end

    def update
      set_user
      check_captcha(render_on_fail: :edit); return if performed?
      if (Time.now.utc - @user.password_reset_sent_at) > 2.hours
        redirect_to new_password_reset_path, alert: "Password reset has expired!"
      elsif @user.update(password_update_params)
        redirect_to root_url, notice: "Password has been reset!"
      else
        render :edit
      end
    end

    private def set_user
      @user = User.find_by(password_reset_token: params[:id])
    end

    private def password_update_params
      params
        .require(:user)
        .permit(:password, :password_confirmation)
    end

  end
end
