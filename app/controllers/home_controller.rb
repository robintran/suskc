class HomeController < ApplicationController
  def index
    @locations = Location.actived_list
    @events = Event.actived_list
    init_news_feed
  end
    
  def search
    if request.post?
      term = params[:term]
      unless term.blank?
        @locations = Location.search(term)
        @events = Event.search(term)
        init_news_feed
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

  private
    def init_news_feed
      @news_feeds = []
      @t_accounts = []
      t_accounts = Setting.where(name: 'twitters').first 
      @t_accounts = t_accounts.svalue.split(',') if t_accounts
      @t_accounts.each do |name|
        @news_feeds += Twitter.user_timeline(name)
      end
    end
end
