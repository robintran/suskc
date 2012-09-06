class SessionsController < ApplicationController
  def new
    redirect_to root_path if current_user 
    @errors = [flash[:alert]]
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      if user.confirmed?
        session[:user_id] = user.id
      else
        @errors = ["Your account has not been confirmed, please check your email to confirm before you can login."]
      end
    else
      @errors = ["Invalid email or password"]     
    end
    respond_to :js
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
