class TweetEngine::AutoResponseController < ApplicationController
  before_filter :find_user
  before_filter :find_search_results
  
  layout 'tweet_engine'
  
  def index
    @auto_responses = TweetEngine::Responder.all
  end
  
  def new
    @user = TweetEngine.whats_my.user
    @auto_response = TweetEngine::Responder.new
  end
  
  def create
    @auto_response = TweetEngine::Responder.new params[:tweet_engine_responder]
    if @auto_response.save
      flash[:notice] = 'Added new auto-response'
      redirect_to tweet_engine_path
    else
      render :new
    end
  end
  
  def edit
    @auto_response = TweetEngine::Responder.find params[:id]
  end
  
  def update
    @auto_response = TweetEngine::Responder.find params[:id]
    if @auto_response.update_attributes params[:tweet_engine_responder]
      flash[:notice] = 'Updated auto-response'
      redirect_to tweet_engine_path
    else
      render :edit
    end
  end
  
  protected
  
  def find_user
    @user = TweetEngine.whats_my.user
  end
  
  def find_search_results
    @latest_search_results = TweetEngine::SearchResult.paginate :per_page => 5, :page => 1
  end
end