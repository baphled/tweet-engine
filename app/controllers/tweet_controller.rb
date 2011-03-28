#
# Controller used to manage our tweet stack
#
class TweetController < ApplicationController
  
  def create
    @tweet = TweetStack::Stack.create params[:tweet_stack_stack]
    @tweet.deliver
    flash[:notice] = "Added new tweet to the stack"
    redirect_to tweet_stack_path
  end
  
  def edit
    @stack = TweetStack::Stack.find params[:id]
  end
  
  def update
    @tweet = TweetStack::Stack.find params[:id]
    @tweet.update_attributes params[:tweet_stack_stack]
    flash[:notice] = "Updated the tweet"
    redirect_to tweet_stack_path
  end
  
  def destroy
    @tweet = TweetStack::Stack.find params[:id]
    @tweet.destroy
    flash[:notice] = "Removed the tweet from the stack"
    redirect_to tweet_stack_path
  end
end