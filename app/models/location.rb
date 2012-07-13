class Location < ParseResource::Base

  fields :name, :description, :physical_addr, :phone, :email, :url, :twitter, :facebook, :latitude, :longitude, :gmaps
  has_many :categories

end

