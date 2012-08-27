class Event < ParseResource::Base
  fields :address, :active, :company_id, :name, :e_time, :recurring, :location, :url, :description, :latitude, :longitude, :user_id
  
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
end
