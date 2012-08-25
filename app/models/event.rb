class Event < ParseResource::Base
  fields :name, :e_time, :recurring, :location, :url, :description
end
