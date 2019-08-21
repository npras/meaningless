module PrasDevise
  class ConfirmationsController < PrasDeviseController

    def new
    end

    def show
      @user = User.find_by(confirmation_token: params[:confirmation_token])

      if (Time.now.utc - @user.confirmation_sent_at) > 1.hours
        redirect_to new_confirmation_path, alert: "Confirmation token has expired. Ask admin to re-send you the confirmation email." and return
      end

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

