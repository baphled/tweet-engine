class TweetEngine::EngineController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  before_filter :tweet_stack, :only => [:index]
  before_filter :instantiate_stack, :only => [:index]
  
  def index
  end
  
  def search
    @results = TweetEngine.search params[:q]
    @term = params[:q]
  end
  
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
  
  def stack
    TweetEngine.stack params[:message]
    flash[:notice] = "Added new tweet to the stack"
    redirect_to tweet_engine_path
  end
  
  def following
    @following = TweetEngine.following
  end
  
  def followers
    @followers = TweetEngine.followers
  end
  
  def unfollow
    @unfollowed = []
    params[:unfollow].each do |screen_name|
      @unfollowed << Twitter.unfollow(screen_name.last)
    end
    flash[:notice] = "Unfollowed #{@unfollowed.count} tweeple"
    redirect_to tweet_engine_path
  end
  
  protected
  
  def potential_followers
    @potential_followers = TweetEngine::SearchResult.all.to_a
  end
  
  def tweet_stack
    @tweet_stack = TweetEngine::Stack.all
  end
  
  def instantiate_stack
    @stack = TweetEngine::Stack.new
  end
end