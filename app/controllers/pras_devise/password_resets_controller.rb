module PrasDevise
  class PasswordResetsController < PrasDeviseController

    before_action :load_recaptcha_secrets, only: %i(new create)

    def new
    end

    def create
      check_captcha(action_to_render_on_fail: :new); return if performed?
      user = User.find_by(email: params[:email])
      user&.send_password_reset!

      redirect_to root_url, notice: "If you had registered, you'd receive password reset email shortly"
    end

    def edit
      @user = User.find_by(password_reset_token: params[:id])
    end

    def update
      @user = User.find_by(password_reset_token: params[:id])
      if (Time.now.utc - @user.password_reset_sent_at) > 2.hours
        redirect_to new_password_reset_path, alert: "Password reset has expired!"
      elsif @user.update(password_update_params)
        redirect_to root_url, notice: "Password has been reset!"
      else
        render :edit
      end
    end

    private def password_update_params
      params
        .require(:user)
        .permit(:password, :password_confirmation)
    end

  end
end
