class Point
  def self.make_point(location)
    point = {}
    point[:lat] = location.latitude
    point[:lng] = location.longitude
    point[:data] = {company: location.name, email: location.email}
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
