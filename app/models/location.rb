class Location < ParseResource::Base
  
  fields :name, :description, :address, :phone, :email, :url, :twitter, :facebook, :latitude, :longitude
  
  validates :address, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :description, presence: true
  
  def categories
    cat_locs = CategoryLocation.where(location_id: self.id)
    locations = []
    cat_locs.each do |cat_loc|
      locations << cat_loc.category
    end
    return locations
  end
  
end

