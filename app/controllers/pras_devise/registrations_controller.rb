module PrasDevise
  class RegistrationsController < PrasDeviseController

    prepend_before_action :require_no_authentication, only: %i(new create)
    before_action :load_recaptcha_secrets, only: %i(new create)

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      check_captcha; return if performed?
      @user.unconfirmed_email = @user.email
      if @user.save
        @user.send_confirmation_instructions!
        redirect_to root_url, notice: "Check your email with subject 'Confirmation instructions'"
      else
        render :new
      end
      #@user.generate_token(:remember_token)
      #if @user.save
      #cookies.encrypted[:remember_token] = @user.remember_token # also login the user
      #redirect_to root_url, notice: "Thank you for signing up! You are logged in."
      #else
      #render :new
      #end
    end

    private def user_params
      params
        .require(:user)
        .permit(:name, :email, :password, :password_confirmation)
    end

  end
end
