module PrasDevise
  class SessionsController < PrasDeviseController

    before_action :load_recaptcha_secrets, only: %i(new create)

    def new
    end

    def create
      @user = User.find_by(email: params[:email])

      recaptcha_success_v3 = verify_recaptcha(site_key: @v3_site_key, secret_key: @v3_secret_key, model: @user, action: :login)
      recaptcha_success_v2 = verify_recaptcha(site_key: @v2_site_key, secret_key: @v2_secret_key) unless recaptcha_success_v3

      if recaptcha_success_v3 || recaptcha_success_v2
        if @user&.authenticate(params[:password])
          login!
          redirect_to after_sign_in_path_for(:user), notice: "Logged in!"
        else
          flash.now.alert = "Email or password is invalid"
          render :new
        end
      else
        @show_checkbox_recaptcha = true unless recaptcha_success_v3
        flash.now.alert = "I suspect you are a BOT!"
        render :new
      end
    end

    def destroy
      cookies.delete(:remember_token)
      #session[:user_id] = nil
      redirect_to root_url, notice: "Logged out!"
    end

    private def login!
      if params[:remember_me]
        cookies.encrypted.permanent[:remember_token] = @user.remember_token
      else
        cookies.encrypted[:remember_token] = @user.remember_token
      end
    end

  end
end
