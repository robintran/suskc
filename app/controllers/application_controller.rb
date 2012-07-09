class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  def current_user
    return session[:user_id] ? User.find(session[:user_id]) : nil
  end
  
end
