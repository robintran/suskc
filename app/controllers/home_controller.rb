class HomeController < ApplicationController
  def index
    @locations = Location.actived_list
    @events = Event.actived_list
    @news_feeds = Twitter.user_timeline("mytest1221") + Twitter.user_timeline('railstutorial')
  end
    
  def search
    if request.post?
      term = params[:term]
      unless term.blank?
        @locations = Location.search(term)
        @events = Event.search(term)
        render :index
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
  
  def update_map
    @locations = []
    @locations = Location.where(category: params[:category], active: true)
    @locations = Location.actived_list if params[:category] == 'all'
    points = Point.get_points(@locations, []).to_json
    respond_to do |format|
      format.json { render :json => points }
    end
  end

end
