class CategoryLocation < ParseResource::Base
  belongs_to :category
  belongs_to :location
  
  def category
    Category.find(self.category_id)
  end
  
  def location
    Location.find(self.location_id)
  end
  
end
