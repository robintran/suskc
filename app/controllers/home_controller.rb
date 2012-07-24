class HomeController < ApplicationController
  def index
    @locations = Location.actived_list
    @categories = Category.all
  end
    
  def search
    term = params[:term]
    unless term.blank?
      @locations = Location.search(term)
      @categories = Category.all
      render :index
    else
      redirect_to root_path
    end
  end
  
  def update_map
    @locations = []
    if params[:category] && params[:category] != 'all'
      @category = Category.find params[:category]
      @locations = @category.active_locations
    end
    @locations = Location.actived_list if params[:category] == 'all'
    points = Point.get_points(@locations).to_json
    respond_to do |format|
      format.json { render :json => points }
    end
  end
  
end
