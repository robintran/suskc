class Admin::DashboardController < ApplicationController
  before_filter :authenticate_admin, except: [:first_admin, :create_first_admin]
  layout 'admin'
  def index
    init
    @user = current_user
    @show_tab = '1'
    @show_tab = params[:tab] unless params[:tab].blank?
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
    @show_tab = @user.id == current_user.id ? '1' : '2'
    if @errors.blank?
      @user.update_attributes(params[:user])
      if @user.errors.blank?
        flash[:notice] = "update successful!"
        redirect_to '/admin'
      else
        @display_form = true
        @errors = @user.errors.full_messages
        init
        render :index
      end
    else
      @display_form = true
      init
      render :index
    end
  end
  
  private
  
    def init
      @users = User.all
      @locations = Location.all
      
      @registed_users = User.where(role: 'user')
      @confirmed_users = User.where(role: 'user', confirm_code: 'confirmed')
      
      @actived_locations = Location.where(status: 'actived')
      @unactived_locations = @locations - @actived_locations
    end
end
