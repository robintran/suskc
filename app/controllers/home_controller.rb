class HomeController < ApplicationController
  def index
    @locations = Location.all
    @categories = Category.all
  end
  
  def update_map
    @category = Category.find params[:category]
    @locations = @category.locations
    @locations = Location.all if @locations.blank?
    points = Point.get_points(@locations).to_json
    respond_to do |format|
      format.json { render :json => points }
    end
  end
  
end
