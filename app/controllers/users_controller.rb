class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @user = User.new params[:user]
    @user.role = "user"
    @user.save
    @errors = @user.errors.full_messages
    @errors << "password confirmation is not matched" if params[:user][:password] != params[:password_confirmation]
    if @errors.blank?
      redirect_to home_path
    else
      render :new
    end
  end
end
