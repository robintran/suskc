class SessionsController < ApplicationController
  def new
    @errors = [flash[:alert]]
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      url = user.admin? ? "/admin" : root_url
      redirect_to url, :notice => "logged in !"
    else
      @errors = ["Invalid email or password"]
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
