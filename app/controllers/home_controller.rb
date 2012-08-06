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
    @locations = get_locations(params[:category]) if(params[:category] && params[:category] != 'all')
    @locations = Location.actived_list if params[:category] == 'all'
    points = Point.get_points(@locations).to_json
    respond_to do |format|
      format.json { render :json => points }
    end
  end

  private
    def get_locations(category_name)
      locations = []
      category = Category.where(name: category_name).first
      locations = category.active_locations if category
      return locations
    end
end
