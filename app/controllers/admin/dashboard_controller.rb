class Admin::DashboardController < ApplicationController
  before_filter :authenticate_admin, except: [:first_admin, :create_first_admin]
  layout 'admin'
  def index
    @user = current_user
  end
  
  def first_admin
    unless first_access
      redirect_to '/signin'
    else
      @user = User.new
    end
  end
  
  def create_first_admin
    unless first_access
      redirect_to '/signin'
    else
      @errors = []
      @user = User.new params[:user]
      @errors << "password confirmation is not matched" if params[:user][:password] != params[:password_confirmation]
     
      if @errors.blank?
        @user.role = "admin"
        if @user.save
          flash[:notice] = 'Create Admin successful'
          redirect_to '/signin'
        else
          @errors = @user.errors.full_messages
          render :first_admin
        end
      else
        render :first_admin
      end
    end
  end
  
  def update_user
    @errors = []
    unless params[:user][:password].blank? && params[:password_confirmation].blank?
      @errors << "password confirmation is not matched" if params[:user][:password] != params[:password_confirmation]
    else
      params[:user].delete(:password)
    end
    @user = User.find params[:id]
    render_path = @user.id == current_user.id ? 'index' : 'edit_user'
    if @errors.blank?
      @user.update_attributes(params[:user])
      if @user.errors.blank?
        flash[:notice] = "update successful!"
        redirect_to '/admin'
      else
        @display_form = true
        @errors = @user.errors.full_messages
        render render_path
      end
    else
      @display_form = true
      render render_path
    end
  end
  
end
