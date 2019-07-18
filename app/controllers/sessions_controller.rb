class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      login!
      redirect_to root_url, notice: "Logged in!"
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
      cookies[:remember_token] = @user.remember_token
    end
  end

end
