class Point
  def self.make_point(location)
    point = {}
    point[:lat] = location.latitude
    point[:lng] = location.longitude
    point[:data] = {id: location.id, name: location.name, email: location.email, address: location.address, phone: location.phone, url: location.url, twitter: location.twitter, facebook: location.facebook, description: location.description}
    
    icon = "http://maps.google.com/mapfiles/ms/icons/purple-dot.png" if location.paid
    point[:options] = {clickable: true, icon: icon}
    return point 
  end
  
  def self.get_points(locations)
    points = []
    unless locations.blank?
      locations.each do |location|
        points << make_point(location)
      end
    end
    return points
  end
  
  def self.get_cat_points(cat_name)
    category = Category.where(name: cat_name).first
    locations = category.active_locations if category
    return get_points(locations)
  end
end
