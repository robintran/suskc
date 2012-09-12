class Event < ParseResource::Base
  fields :address, :active, :company_id, :email, :name, :e_time, :recurring, :url, :description, 
          :latitude, :longitude, :user_id, :phone
  
  validates :e_time, presence: true
  validates :name, presence: true
  
  def active?
    return self.active==true ? 'actived' : 'unactived'
  end
  
  def user
    User.find(self.user_id)
  end
  
  def self.actived_list
    where(active: true).sort_by{|e| e.name}
  end
  
  def self.unactived_list
    where(active: false) | where(active: nil)
  end
  
  def self.search term
    all_events = where(active: true)
    events = all_events.select{|e| 
      e.name.downcase.include?(term.downcase) || 
      (e.address && e.address.downcase.include?(term.downcase)) || 
      e.description.downcase.include?(term.downcase)
    }
    return events
  end
  
  def company
    com = self.company_id ? Location.find(self.company_id) : nil
    return com
  end
  
  def datetime
    begin
      date = DateTime.strptime(self.e_time, "%m/%d/%Y %I:%M %p")
    rescue
      begin
        date = DateTime.strptime(self.e_time, "%m/%d/%Y %H:%M")
      rescue
        date = DateTime.strptime(self.e_time, "%m/%d/%Y")
      end
    end
    return date
  end
  
  def e_address
    addr = company ? company.address : address
    if addr.blank? && latitude && longitude
      geo = Geokit::Geocoders::GoogleGeocoder.reverse_geocode("#{latitude},#{longitude}")
      addr = geo.full_address
      self.update_attributes(address: addr)
    end
    addr
  end
  
end
