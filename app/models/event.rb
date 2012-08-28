class Event < ParseResource::Base
  fields :address, :active, :company_id, :name, :e_time, :recurring, :url, :description, :latitude, :longitude, :user_id
  
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
end
