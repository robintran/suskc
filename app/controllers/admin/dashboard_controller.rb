class Admin::DashboardController < ApplicationController
  before_filter :authenticate_admin, except: [:first_admin, :create_first_admin]
  layout 'admin'
  
  def active_location
    @location = Location.find params[:id]
    active = !@location.active
    @location.update_attributes(active: active)
    respond_to :js
  end
  
  def active_event
    @event = Event.find params[:id]
    active = !@event.active
    @event.update_attributes(active: active)
    respond_to :js
  end
  
  def location_filter
    status = params[:status]
    @locations = Location.actived_list if status=='active'
    @locations = Location.unactived_list if status=='unactive'
    respond_to :js
  end
  
  def event_filter
    status = params[:status]
    @events = Event.actived_list if status=='active'
    @events = Event.unactived_list if status=='unactive'
    respond_to :js
  end
  
  def import_locations
    success_count = 0
    fails_count = 0
    uploader = FileUploader.new
    begin
      require 'csv'
      
      random = (0...8).map{65.+(rand(25)).chr}.join
      params[:file].original_filename = "#{random}_#{params[:file].original_filename}" 
      uploader.store!(params[:file])

      csv_text = File.read(uploader.path, { encoding: "UTF-8" })
      
      csv = CSV.parse(csv_text, :headers => true)
      
      csv.each do |row|
        @location = Location.new
        @location.name = row[0]
        @location.description = row[1]
        @location.address = row[2]
        @location.phone = row[3]
        @location.email = row[4]
        @location.url = row[5]
        @location.twitter = row[6]
        @location.facebook = row[7]
        @location.active = row[8].blank? ? false : (row[8].downcase=='true' ? true : false)
        @location.paid = row[9].blank? ? false : (row[9].downcase=='true' ? true : false)
        @location.logo = row[10] unless row[10].blank?
        
        user = User.where(username: row[11]).first
        user = current_user unless user
        
        @location.user_id = user.id
        @location.category = row[12]
        @location.sub_category = row[13]
        
        if(check_row(row))
          @location.save
          if @location.errors.blank?
            success_count += 1
          else
            fails_count += 1
            puts @location.errors.full_messages
            flash[:alert] = @location.errors.full_messages.first
          end
        else
          fails_count += 1
        end
      end
      uploader.remove!
    rescue Exception => e
      flash[:alert] = e.message
      uploader.remove!
    end
    
    flash[:notice] = "#{success_count} imported, #{fails_count} fails"
    redirect_to '/admin'
  end
  
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
  
  def update_cost
    @cost = params[:cost]
    setting_cost = Setting.where(name: 'up_cost').first
    setting_cost.update_attributes(value: @cost)
    respond_to :js
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
      @events = Event.all
      setting_cost = Setting.where(name: 'up_cost').first
      setting_cost = Setting.create(name: 'up_cost', value: 1.00) unless setting_cost
      @upgrade_cost = setting_cost.value
      @registed_users = User.where(role: 'user')
      @confirmed_users = User.where(role: 'user', confirm_code: 'confirmed')
      
      @actived_locations = Location.actived_list
      @unactived_locations = Location.unactived_list
      @actived_events = Event.actived_list
      @unactived_events = Event.unactived_list
    end
    
    def check_valid_address address
      addr = Geokit::Geocoders::GoogleGeocoder.geocode(address)
      if addr.success
        @location.latitude = addr.lat
        @location.longitude = addr.lng
        return true
      else
        return false
      end
    end
    
    def check_row row
      return false if (row[0].blank? || row[2].blank? || row[3].blank? || row[4].blank?)
      return false if (row[0]=='n/a' || row[2]=='n/a' || row[3]=='n/a' || row[4]=='n/a')
      return false unless check_valid_address(row[2])
      return true
    end
end
