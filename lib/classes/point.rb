class Point
  def self.make_point(location)
    point = {}
    point[:lat] = location.latitude
    point[:lng] = location.longitude
    logo = location.logo 
    logo = "/assets/think-big.png" if logo.blank?
    point[:data] = {id: location.id, name: location.name, email: location.email, address: location.address, phone: location.phone, url: location.url, twitter: location.t_user, facebook: location.f_user, description: location.description, logo: logo, events: location.js_events.to_json, category: location.category}
    
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
    e_time = event.datetime.strftime("%m/%d%Y %I:%M %p");
    point[:data] = {id: event.id, ptype: "event", name: event.name, address: event.e_address,e_time: e_time, recurring: event.recurring, 
        url: event.url, description: event.description}
    return point
  end
  
  def self.get_points(locations, events)
    points = []
    unless locations.blank?
      locations.each do |location|
        points << make_point(location) unless(location.latitude.blank? || location.longitude.blank?)
      end
    end
    unless events.blank?
      events.each do |event|
        points << make_epoint(event) unless(event.latitude.blank? || event.longitude.blank?)
      end
    end
    return points
  end
  
end
