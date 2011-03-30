class TweetEngineController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  before_filter :tweet_stack
  before_filter :instantiate_stack
  
  def index
    @followers = TweetEngine.followers
  end
  
  def search
    @results = TweetEngine.search params[:q]
    @term = params[:q]
    render :index
  end
  
  def follow
    @new_followers = []
    params[:followers].each do |screen_name|
      @new_followers << TweetEngine.follow(screen_name)
    end
    flash[:notice] = "You are now following #{pluralize(@new_followers.count, "more person")}"
    render :index
  end
  
  def stack
    TweetEngine.stack params[:message]
    flash[:notice] = "Added new tweet to the stack"
    redirect_to tweet_engine_path
  end
  
  def following
    @followers = TweetEngine.following
  end
  
  def unfollow
    Twitter.unfollow params[:screen_name]
    flash[:notice] = "Unfollowing #{params[:screen_name]}"
    redirect_to tweet_engine_path
  end
  
  private
  def tweet_stack
    @tweet_stack = TweetEngine::Stack.all
  end
  
  def instantiate_stack
    @stack = TweetEngine::Stack.new
  end
end