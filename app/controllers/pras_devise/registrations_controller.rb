module PrasDevise
  class RegistrationsController < PrasDeviseController

    prepend_before_action :require_no_authentication, only: %i(new create)
    before_action :load_recaptcha_secrets, only: %i(new create)

    def new
      @user = User.new
    end

    def create
      @user = User.find_or_initialize_by(unconfirmed_email: user_params[:email])
      @user.attributes = user_params
      check_captcha; return if performed?
      if @user.save
        @user.generate_token_and_send_instructions!(token_type: :confirmation)
        redirect_to root_url, notice: "Check your email with subject 'Confirmation instructions'"
      else
        render :new
      end
    end

    private def user_params
      params
        .require(:user)
        .permit(:name, :email, :password, :password_confirmation)
    end

  end
end
