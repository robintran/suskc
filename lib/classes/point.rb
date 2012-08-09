class Point
  def self.make_point(location)
    point = {}
    point[:lat] = location.latitude
    point[:lng] = location.longitude
    logo = location.logo 
    logo = "/assets/think-big.png" if logo.blank?
    point[:data] = {id: location.id, name: location.name, email: location.email, address: location.address, phone: location.phone, url: location.url, twitter: location.twitter, facebook: location.facebook, description: location.description, logo: logo}
    
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
  
end
