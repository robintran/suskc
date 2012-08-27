class EventsController < ApplicationController
  def create
    @event = Event.new params[:event]
    @errors = []
    if params[:use_company] == '1'
      @event.address = nil
      company = Location.find @event.company_id
      @event.latitude = company.latitude
      @event.longitude = company.longitude
    elsif @event.address
      @event.company_id = nil
      addr = Geokit::Geocoders::GoogleGeocoder.geocode(@event.address)
      if addr.success
        @event.latitude = addr.lat
        @event.longitude = addr.lng
      else
        @errors << "invalid address"
      end
    end
    @event.active = true
    @event.user_id = current_user.id
    @event.save
    
    respond_to :js
  end
end
