class TweetEngine::PotentialFollowersController < TweetEngineController
  
  #
  # GET /tweet-engine/potential-followers
  #
  # Gathers a list of all the potential followers built up from
  # doing our background searches. Here we can manually follow these users.
  #
  def index
    @potential_followers = TweetEngine::SearchResult.paginate :per_page => 10, :page => params[:page]
  end
  
  def destroy
    @potential_follower = TweetEngine::SearchResult.find params[:id]
    @potential_follower.destroy
    flash[:notice] = "Removed the search result from the stack"
    redirect_to tweet_engine_potential_followers_path
  end
end