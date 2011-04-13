#
# Controller used to manage our tweet stack
#
class TweetEngine::TweetController < ApplicationController
  before_filter :find_user
  
  def create
    @tweet = TweetEngine::Stack.create params[:tweet_engine_stack]
    flash[:notice] = "Added new tweet to the stack"
    redirect_to tweet_engine_path
  end
  
  def edit
    @stack = TweetEngine::Stack.find params[:id]
  end
  
  def update
    @tweet = TweetEngine::Stack.find params[:id]
    @tweet.update_attributes params[:tweet_engine_stack]
    flash[:notice] = "Updated the tweet"
    redirect_to tweet_engine_path
  end
  
  def destroy
    @tweet = TweetEngine::Stack.find params[:id]
    @tweet.destroy
    flash[:notice] = "Removed the tweet from the stack"
    redirect_to tweet_engine_path
  end
  
  protected
  
  def find_user
    @user = TweetEngine.whats_my.user
  end
  
end