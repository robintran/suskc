class HomeController < ApplicationController
  def index
    @locations = Location.all
    @categories = Category.all
  end
  
  def update_map
    @category = Category.find params[:category]
    @locations = @category.locations
    @locations = Location.all if @locations.blank?
  end
  
end
