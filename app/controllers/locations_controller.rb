class LocationsController < ApplicationController
  before_filter :authenticate_user
  
  def new
    @location = Location.new
  end
  
  def create
    @errors = []
    @location = Location.new params[:location]
    @location.user_id = current_user.id
    @location.active=false
    addr = Geokit::Geocoders::GoogleGeocoder.geocode(@location.address)
    if addr.success
      @location.latitude = addr.lat
      @location.longitude = addr.lng
    else
      @errors << "invalid address"
    end
    
    if @errors.blank?
      if @location.save   
        if params[:logo]
          uploader = LogoUploader.new
          params[:logo].original_filename = "#{@location.id}_#{params[:logo].original_filename}" 
          uploader.store!(params[:logo])
          @location.logo = uploader.url
          unless @location.save
            @errors += @location.errors.full_messages
          end
        end
      else
        @errors += @location.errors.full_messages
      end
    end
    
    respond_to :js

#    if @errors.blank?
#      if @location.save   
#        params[:category].each do |id|
#          cat_loc = CategoryLocation.create(category_id: id, location_id: @location.id)
#        end
#        if params[:logo]
#          uploader = LogoUploader.new
#          params[:logo].original_filename = "#{@location.id}_#{params[:logo].original_filename}" 
#          uploader.store!(params[:logo])
#          @location.logo = uploader.url
#          if @location.save
#            redirect_to root_path, notice: "Location created successfuly. Please wait for us to active"
#          else
#            @errors += @location.errors.full_messages
#            render :new
#          end
#        else
#          redirect_to root_path, notice: "Location created successfuly. Please wait for us to active"
#        end
#      else
#        @errors += @location.errors.full_messages
#        render :new
#      end
#    else
#      render :new
#    end   
  end
  
end
