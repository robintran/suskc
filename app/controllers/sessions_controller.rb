class SessionsController < ApplicationController
  def new
    redirect_to root_path if current_user 
    @errors = [flash[:alert]]
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      url = user.admin? ? "/admin" : root_url
      redirect_to url
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
