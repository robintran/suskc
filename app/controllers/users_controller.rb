class UsersController < ApplicationController
  before_filter :authenticate_user, only: [:my_account]
  
  def confirm_email
    user = User.where(confirm_code: params[:code]).first
    if user
      user.update_attributes(confirm_code: 'confirmed')
      redirect_to '/', notice: 'Your email has been confirm successfully'
    else
      redirect_to '/', notice: 'Confirm code wrong or it has been used'
    end
  end
  
  def create
    @errors = []
    @user = User.new params[:user]
    @errors << "password confirmation is not matched" if params[:user][:password] != params[:password_confirmation]
   
    if @errors.blank?
      @user.role = "user"
      confirm_code = Digest::SHA1.hexdigest([Time.now, rand].join)
      confirm_url = "http://#{request.host_with_port}/confirm_email/#{confirm_code}"
      @user.confirm_code = confirm_url
      if @user.save
        ConfirmMailer.email_confirm(@user.username, confirm_url).deliver
        redirect_to home_path, notice: 'A confirm email has been sent to your email address'
      else
        @errors = @user.errors.full_messages
        render :new
      end
    else
      render :new
    end
  end
  
  def my_account
    @user = current_user
    @locations = @user.locations
  end
  
  def new
    @user = User.new
  end
  
end
