class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :authenticate_user
  
  def current_user
    return session[:user_id] ? User.find(session[:user_id]) : nil
  end
  
  def authenticate_user
    unless session[:user_id]
      flash[:alert] = "Please login first"
      redirect_to "/signin"
    end
  end
  
end
