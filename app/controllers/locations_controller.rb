class LocationsController < ApplicationController
  def new
    @location = Location.new
  end
  
  def create
    @errors = []
    @location = Location.new params[:location]
    addr = Geokit::Geocoders::GoogleGeocoder.geocode(@location.address)
    if addr.success
      @location.latitude = addr.lat
      @location.longitude = addr.lng
    else
      @errors << "invalid address"
      render :new
    end
    
    if @errors.blank?
      if @location.save   
        params[:category].each do |id|
          cat_loc = CategoryLocation.create(category_id: id, location_id: @location.id)
        end
        redirect_to root_path
      else
        @errors += @location.errors.full_messages
        render :new
      end
    else
      render :new
    end   
  end
  
end
