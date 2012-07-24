class Category < ParseResource::Base
  
  fields :name  
  has_many :locations
  
  def active_locations
    locations.select{|l| l.active == true}
  end
  
  def locations
    cat_locs = CategoryLocation.where(category_id: self.id)
    locs = []
    cat_locs.each do |cat_loc|
      locs << cat_loc.location
    end
    return locs
  end
  
end
