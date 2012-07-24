class Point
  def self.make_point(location)
    point = {}
    point[:lat] = location.latitude
    point[:lng] = location.longitude
    point[:data] = {id: location.id, company: location.name, email: location.email, address: location.address}
    first_cat = location.categories.first
    if first_cat
      icon = "../assets/bg-digital.png" if first_cat.name == 'Digital Company'
      icon = "../assets/bg-investors.png" if first_cat.name == 'Investor'
      icon = "../assets/bg-coworking.png" if first_cat.name == 'Coworking Space'
    end
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
