module PrasDevise
  class ConfirmationsController < PrasDeviseController

    def show
      @user = User.find_by(confirmation_token: params[:confirmation_token])
      if @user
        @user.email, @user.unconfirmed_email = @user.unconfirmed_email, nil
        @user.confirmed_at = Time.now.utc
        @user.save
        redirect_to root_url, notice: "You are confirmed! You can now login."
      else
        redirect_to root_url, alert: "No user found for this token"
      end
    end

  end
end

