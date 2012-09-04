class LocationsController < ApplicationController
  before_filter :authenticate_user, except: [:locations_by_category]
  
  def new
    @location = Location.new
  end
  
  def create
    @errors = []
    @location = Location.new params[:location]
    @location.user_id = current_user.id
    @location.active = false
    @location.paid = false
    check_valid_address(@location.address)
    
    if params[:logo]
      begin
        uploader = LogoUploader.new
        params[:logo].original_filename = "#{@location.id}_#{params[:logo].original_filename}" 
        uploader.store!(params[:logo])
        @location.logo = uploader.url
      rescue Exception => e
        @errors << e
      end
    end
    
    if @errors.blank?
      @location.save   
      @errors += @location.errors.full_messages
    end
    
    respond_to :js 
  end
  
  def locations_by_category
    @locations = Location.where(category: params[:category], active: true)
    @icon_class = params[:icon_class]
    respond_to :js
  end
  
  def update
    @errors = []
    @location = Location.find params[:id]
    check_valid_address(params[:location][:address])
    
    if @errors.blank?
      @location.update_attributes(params[:location])
      @errors += @location.errors.full_messages
    end
    
    respond_to :js
  end
  
  def check_valid_address address
    addr = Geokit::Geocoders::GoogleGeocoder.geocode(address)
    if addr.success
      @location.latitude = addr.lat
      @location.longitude = addr.lng
    else
      @errors << "invalid address"
    end
  end
  
end
