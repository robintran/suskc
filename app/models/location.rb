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
  
  def self.actived_list
    where(active: true).sort_by{|loc| loc.name}
  end
  
  def self.unactived_list
    where(active: false) | where(active: nil)
  end
  
  def self.search term
    all_locs = where(active: true)
    by_name = all_locs.select{|loc| loc.name.downcase.include?(term.downcase)}
    by_address = all_locs.select{|loc| loc.address.downcase.include?(term.downcase)}
    by_desc = all_locs.select{|loc| loc.description.downcase.include?(term.downcase)}
    return(by_name | by_address | by_desc)
  end
  
end

