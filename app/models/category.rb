class Category < ParseResource::Base
  
  fields :name  
  has_many :locations
  
end
