class LocationsController < ApplicationController
  def new
    @location = Location.new
  end
  
  def create
    @location = Location.new params[:location]
    @location.save
    @errors = @location.errors.full_messages
    if @errors.blank?
      addr = Geokit::Geocoders::GoogleGeocoder.geocode(@location.address)
      if addr.success
        @location.update_attributes(latitude: addr.lat, longitude: addr.lng)
        redirect_to root_path
      else
        @errors << "invalid address"
        render :new
      end
    else
      render :new
    end
  end
  
end
