class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @errors = []
    @user = User.new params[:user]
    @errors << "password confirmation is not matched" if params[:user][:password] != params[:password_confirmation]
   
    if @errors.blank?
      @user.role = "user"
      if @user.save
        redirect_to home_path
      else
        @errors = @user.errors.full_messages
        render :new
      end
    else
      render :new
    end
  end
end
