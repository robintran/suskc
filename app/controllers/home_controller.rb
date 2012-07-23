class HomeController < ApplicationController
  def index
    @locations = Location.active_list
    @categories = Category.all
  end
  
  def update_map
    if params[:category] && params[:category] != 'all'
      @category = Category.find params[:category]
      @locations = @category.locations
    end
    @locations = Location.active_list if @locations.blank?
    points = Point.get_points(@locations).to_json
    respond_to do |format|
      format.json { render :json => points }
    end
  end
  
end
