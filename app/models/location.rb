class Location < ParseResource::Base
  belongs_to :user
  fields :name, :description, :address, :phone, :email, :url, :twitter, :facebook, :latitude, :longitude,
         :active, :paid, :logo, :user_id, :category
  
  validates :address, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :description, presence: true
    
  CATEGORIES = ["Startup", "Accelerator", "Coworking", "Investor", "Education", "Service Providers", "Community"] 
  STARTUP_SUBS = ["Advertising", "BioTech", "eCommerce", "Enterprise", "Games", "Mobile", "Security", "Social", "Other"]
  
  #['Digital Company', 'Investor', 'Coworking Space', 'Accelerator', 'Freelancer', 'Startup', 'Hiring']


  def active?
    return self.active==true ? 'actived' : 'unactived'
  end
  
  def events
    Event.where(company_id: self.id)
  end
  
  def js_events
    events_arr = []
    loc_events = Event.where(company_id: self.id)
    loc_events.each do |e|
      event = {id: e.id, name: e.name, e_time: e.e_time}
      events_arr << event
    end
    return events_arr
  end
  
  def user
    User.find(self.user_id)
  end
  
  def self.actived_list
    where(active: true).sort_by{|loc| loc.name}
  end
  
  def self.unactived_list
    where(active: false) | where(active: nil)
  end
  
  def self.search term
    all_locs = where(active: true)
    locations = all_locs.select{|loc| 
      loc.name.downcase.include?(term.downcase) || 
      loc.address.downcase.include?(term.downcase) || 
      loc.description.downcase.include?(term.downcase)
    }
    return locations
  end
  
end

