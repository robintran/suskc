class Point
  def self.make_point(location)
    point = {}
    point[:lat] = location.latitude
    point[:lng] = location.longitude
    point[:data] = {id: location.id, company: location.name, email: location.email, address: location.address}
    
    icon = "http://maps.google.com/mapfiles/ms/icons/purple-dot.png" if location.user.is_member?
    point[:options] = {clickable: true, icon: icon}
    return point 
  end
  
  def self.get_points(locations)
    points = []
    locations.each do |location|
      points << make_point(location)
    end
    return points
  end
end
