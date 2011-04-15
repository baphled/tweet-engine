class TweetEngineController < ApplicationController
  before_filter :find_user
  before_filter :find_search_results
  
  layout 'tweet_engine'
  
  protected
  
  def find_user
    @user = TweetEngine.whats_my.user
  end
  
  def find_search_results
    @latest_search_results = TweetEngine::SearchResult.paginate :per_page => 5, :page => 1
  end
  
end