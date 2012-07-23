class Location < ParseResource::Base
  belongs_to :user
  fields :name, :description, :address, :phone, :email, :url, :twitter, :facebook, :latitude, :longitude, :active
  
  validates :address, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :description, presence: true
  
  
  def active?
    return self.active==true ? 'actived' : 'unactived'
  end
  
  def self.active_list
    where(active: true)
  end
  
  def categories
    cat_locs = CategoryLocation.where(location_id: self.id)
    cats = []
    cat_locs.each do |cat_loc|
      cats << cat_loc.category
    end
    return cats
  end
  
  def user
    User.find(self.user_id)
  end
end

