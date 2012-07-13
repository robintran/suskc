class Location < ParseResource::Base

  fields :name, :description, :address, :phone, :email, :url, :twitter, :facebook, :latitude, :longitude
  belongs_to :user
  has_many :categories

end

