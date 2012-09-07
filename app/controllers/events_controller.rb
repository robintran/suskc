class EventsController < ApplicationController
  def create
    @event = Event.new params[:event]
    @errors = []
    check_valid_address
    @event.active = true
    @event.user_id = current_user.id
    @event.save
    
    respond_to :js
  end
  
  def update
    @event = Event.find params[:id]
    @errors = []
    params[:event][:e_time] = params["event_#{@event.id}"]["e_time"]
    check_valid_address
    if @errors.blank?
      @event.update_attributes(params[:event])
      @errors += @event.errors.full_messages
    end
    respond_to :js
  end
  
  private
    def check_valid_address
      if params[:use_company] && params[:event][:company_id]
        @event.address = nil
        company = Location.find params[:event][:company_id]
        @event.latitude = company.latitude
        @event.longitude = company.longitude
      elsif params[:event][:address]
        @event.company_id = nil
        addr = Geokit::Geocoders::GoogleGeocoder.geocode(params[:event][:address])
        if addr.success
          @event.latitude = addr.lat
          @event.longitude = addr.lng
        else
          @errors << "invalid address"
        end
      end
    end
end
