module PrasDevise
  class SessionsController < PrasDeviseController

    before_action :set_user, only: :create
    before_action :load_recaptcha_secrets, only: %i(new create)
    before_action :check_captcha, only: :create

    def new
    end

    def create
      if @user&.authenticate(params[:password])
        login!
        redirect_to after_sign_in_path_for(:user), notice: "Logged in!"
      else
        flash.now.alert = "Email or password is invalid"
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

    private def set_user
      @user = User.find_by(email: params[:email])
    end

    private def check_captcha
      @recaptcha_success_v2 = verify_recaptcha(site_key: @v2_site_key,
                                               secret_key: @v2_secret_key)

      render :new and return unless @recaptcha_success_v2
    end

  end
end
