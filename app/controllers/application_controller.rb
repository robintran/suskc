class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :authenticate_user, :authenticate_admin
  
  protected
    def current_user
      return session[:user_id] ? User.find(session[:user_id]) : nil
    end
    
    def authenticate_admin
      unless first_access
        unless current_user
          flash[:alert] = "You can not access restricted area"
          redirect_to "/signin"
        else
          if current_user.role != "admin"
            flash[:alert] = "You can not access restricted area"
            redirect_to root_path
          end
        end
      else
        redirect_to admin_first_admin_path
      end
    end
    
    def authenticate_user
      unless session[:user_id]
        flash[:alert] = "Please login first"
        redirect_to "/signin"
      end
    end
  
    def first_access
      admins = User.where(role: 'admin')
      return admins.size == 0
    end
end
