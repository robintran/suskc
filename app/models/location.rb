class Location < ParseResource::Base
  belongs_to :user
  fields :name, :description, :address, :phone, :email, :url, :twitter, :facebook, :latitude, :longitude,
         :active, :paid, :logo, :user_id, :category
  
  validates :address, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :description, presence: true
    
  CATEGORIES = ['Digital Company', 'Investor', 'Coworking Space', 'Accelerator', 'Freelancer', 'Startup', 'Hiring']
  
  def active?
    return self.active==true ? 'actived' : 'unactived'
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

