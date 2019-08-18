class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #

  def password_reset
    @user = params[:user]
    mail to: @user.email, subject: "Password Reset"
  end

  def email_confirmation
    @user = params[:user]
    @email = @user.unconfirmed_email
    @token = @user.confirmation_token

    mail to: @email, subject: "Confirmation instructions"
  end

end
