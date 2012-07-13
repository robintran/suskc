class Location < ParseResource::Base

  fields :name, :description, :physical_addr, :phone, :email, :url, :twitter, :facebook, :latitude, :longitude, :gmaps
  belongs_to :user
  has_many :categories

end

