class EventsController < ApplicationController
  def create
    @event = Event.new params[:event]
    @errors = []
    if params[:use_company] == '1'
      @event.address = nil
    elsif @event.address
      @event.company = nil
      addr = Geokit::Geocoders::GoogleGeocoder.geocode(@event.address)
      if addr.success
        @event.latitude = addr.lat
        @event.longitude = addr.lng
      else
        @errors << "invalid address"
      end
    end
    @event.save
    
    respond_to :js
  end
end
