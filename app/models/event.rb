class Event < ParseResource::Base
  fields :address, :active, :company_id, :email, :name, :e_time, :recurring, :url, :description, 
          :latitude, :longitude, :user_id, :phone
  
  validates :e_time, presence: true
  validates :name, presence: true
  
  def self.actived_list
    where(active: true).sort_by{|e| e.name}
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
      date = DateTime.strptime(self.e_time, "%m/%d/%Y %H:%M")
    rescue
      date = DateTime.strptime(self.e_time, "%m/%d/%Y")
    end
    return date
  end
  
  def e_address
    company ? company.address : address
  end
  
end
