class Location < ActiveRecord::Base
  belongs_to :user
  # fields :name, :description, :address, :phone, :email, :url, :twitter, :facebook, 
  # :latitude, :longitude,
         # :active, :paid, :logo, :user_id, :category, :sub_category
  attr_accessible :name, :description, :address, :phone, :email, :url, :twitter, :facebook, 
               :latitude, :longitude, :active, :paid, :logo, :user_id, :category, :sub_category

  validates :address, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :name, presence: true
  
  STARTUP_SUBS = ["Advertising", "BioTech", "eCommerce", "Enterprise", "Games", "Mobile", "Security", "Social", "Other"]
  CATEGORIES = ["Startup", "Accelerator", "Coworking", "Investor", "Education", "Service Providers", "Community"]

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
  
  def t_user
    t_name = ''
    unless self.twitter.blank?
      t_name = self.twitter.split('/').last
      t_name = t_name ? t_name.split('@').last : ""
    end
    t_name
  end
  
  def f_user
    self.facebook.blank? ? '' : self.facebook.split('/').last 
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

