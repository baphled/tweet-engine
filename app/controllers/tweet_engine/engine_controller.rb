class TweetEngine::EngineController < ApplicationController
  before_filter :find_user
  
  include ActionView::Helpers::TextHelper
  
  #
  # GET /tweet-engine
  #
  # This is the main dashboard
  #
  def index
    @tweet_stack = TweetEngine::Stack.all
    @stack = TweetEngine::Stack.new
    @user = TweetEngine.whats_my.user
  end
  
  #
  # POST /tweet-engine/search
  #
  # Manually search for people to follow
  #
  def search
    @results = TweetEngine.search params[:q]
    @term = params[:q]
  end
  
  #
  # POST /tweet-engine/follow
  #
  # Follow selected people
  #
  def follow
    @new_followers = []
    params[:followers].each do |screen_name|
      screen_name = screen_name.last
      @new_followers << TweetEngine.follow(screen_name)
      TweetEngine::SearchResult.delete_all(:conditions => { :screen_name => screen_name })
    end
    flash[:notice] = "You are now following #{pluralize(@new_followers.count, "more person")}"
    redirect_to tweet_engine_path
  end
  
  #
  # POST /tweet-engine/stack
  #
  # Stack a tweet to send out now
  #
  def stack
    TweetEngine.stack params[:message]
    flash[:notice] = "Added new tweet to the stack"
    redirect_to tweet_engine_path
  end
  
  #
  # GET /tweet-engine/following
  #
  # View people we follow
  #
  # This controller is primarily used to determine whether
  # someone we are following is following us back.
  #
  # @TODO Add more information about the users influence
  #
  def following
    @following = TweetEngine.following
  end
  
  #
  # GET /tweet-engine/followers
  #
  # Displays the people that are following us.
  #
  # We can also unfollow people once they follow us.
  #
  # @TODO We should add information about a person to help to decide whether to unfollow someone or not
  #
  def followers
    @followers = TweetEngine.followers
  end
  
  # POST /tweet-engine/unfollow
  #
  # Unfollows a a group of people
  #
  # This is generally used when we want to clean up our timeline
  #
  def unfollow
    @unfollowed = []
    params[:unfollow].each do |screen_name|
      @unfollowed << Twitter.unfollow(screen_name.last)
    end
    flash[:notice] = "Unfollowed #{@unfollowed.count} tweeple"
    redirect_to tweet_engine_path
  end
  
  #
  # GET /tweet-engine/potential-followers
  #
  # Gathers a list of all the potential followers built up from
  # doing our background searches. Here we can manually follow these users.
  #
  def potential_followers
    @potential_followers = TweetEngine::SearchResult.all.to_a
  end
  
  protected
  
  def find_user
    @user = TweetEngine.whats_my.user
  end
  
end