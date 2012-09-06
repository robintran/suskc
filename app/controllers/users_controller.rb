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
    if(User.where(username: params[:user][:username]).any?)
      @errors << 'Email has already been taken.'
    end
    @errors << "password confirmation is not matched" if params[:user][:password] != params[:password_confirmation]
   
    if @errors.blank?
      @user.role = "user"
      confirm_code = Digest::SHA1.hexdigest([Time.now, rand].join)
      confirm_url = "http://#{request.host_with_port}/confirm_email/#{confirm_code}"
      @user.confirm_code = confirm_url
      if @user.save
        ConfirmMailer.email_confirm(@user.username, confirm_url).deliver
      else
        @errors = @user.errors.full_messages
      end
    end
    respond_to :js
  end
  
  def my_account
    init_card
    @user = current_user
    @locations = @user.locations
    @events = @user.events
  end
  
  def new
    @user = User.new
  end
  
  def charge
    @location = Location.find params[:location]
    redirect_to my_account if @location.paid==true
    # amount in cents
    setting_cost = Setting.where(name: 'up_cost').first
    amount = setting_cost ? setting_cost.value*100 : 100
    @errors = []
    begin
      stripe = YAML.load_file("#{Rails.root}/config/stripe.yml")[Rails.env]
      Stripe.api_key = stripe['secretkey']
      @charge = Stripe::Charge.create(
       :amount => amount.to_i,
       :currency => "usd",
       :customer => current_user.customer_id,
       :description => "payment by #{current_user.username}"
      )
      @location.update_attributes(paid: true)
      flash[:notice] = "successfull charge"
    rescue Exception => e
      @error = e
      @user = current_user
      @locations = @user.locations
      init_card
      render :my_account
      return
    end
    redirect_to my_account_path  
  end
  
  def update_card
    init_card
    @card_errors=[] 
    begin
      if @customer
        @customer.card = params[:card][:token]
        @customer.save
      else
        token = params[:card][:token]
        @customer = Stripe::Customer.create(
          card: token,
          description: "#{current_user.username}"
        )
        current_user.update_attributes(customer_id: @customer.id)
      end
    rescue Exception => e
      @card_errors << e
      render :my_account
      return
    end
    
    @active_card = @customer.active_card
    @card_errors << 'cvc is not accepted' if @active_card.cvc_check == 'fail'
    @card_errors << 'line 1 address is not matched' if @active_card.address_line1_check == 'fail'
    @card_errors << 'zip code is not matched' if @active_card.address_zip_check == 'fail'
    
    if @card_errors.any?
      render :my_account
    else
      redirect_to my_account_path
    end
  end
  
  private
  
    def init_card
      stripe = YAML.load_file("#{Rails.root}/config/stripe.yml")[Rails.env]
      Stripe.api_key = stripe['secretkey']
      customer_id = current_user.customer_id
      begin
        @customer = Stripe::Customer.retrieve(customer_id) if(customer_id)
      rescue Exception => e
        puts e
      end
      
      @active_card = @customer.active_card if @customer
    end
    
end
