class Location < ParseResource::Base
  belongs_to :user
  has_many :categories
  
  fields :name, :description, :address, :phone, :email, :url, :twitter, :facebook, :latitude, :longitude
  
  validates :address, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :description, presence: true
  
end

