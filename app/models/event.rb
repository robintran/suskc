class Event < ParseResource::Base
  fields :address, :company, :name, :e_time, :recurring, :location, :url, :description, :latitude, :longitude
end
