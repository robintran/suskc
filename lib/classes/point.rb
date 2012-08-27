class Point
  def self.make_point(location)
    point = {}
    point[:lat] = location.latitude
    point[:lng] = location.longitude
    logo = location.logo 
    logo = "/assets/think-big.png" if logo.blank?
    point[:data] = {id: location.id, name: location.name, email: location.email, address: location.address, phone: location.phone, url: location.url, twitter: location.twitter, facebook: location.facebook, description: location.description, logo: logo, events: location.js_events}
    
    icon = "http://maps.google.com/mapfiles/ms/icons/purple-dot.png" if location.paid
    point[:options] = {clickable: true, icon: icon}
    return point 
  end
  
  def self.make_epoint(event)
    point = {}
    point[:lat] = event.latitude
    point[:lng] = event.longitude
    icon = "http://maps.google.com/mapfiles/ms/icons/red-pushpin.png"
    point[:options] = {clickable: true, icon: icon}
    
    point[:data] = {id: event.id, ptype: "event", name: event.name, e_time: event.e_time, recurring: event.recurring, 
        url: event.url, description: event.description}
    return point
  end
  
  def self.get_points(locations, events)
    points = []
    unless locations.blank?
      locations.each do |location|
        points << make_point(location)
      end
    end
    unless events.blank?
      events.each do |event|
        points << make_epoint(event)
      end
    end
    return points
  end
  
end
