class TweetController < ApplicationController
  
  def create
    TweetStack.stack params[:message]
    flash[:notice] = "Added new tweet to the stack"
    redirect_to tweet_stack_path
  end
  
  def destroy
    stack = TweetStack::Stack.find params[:id]
    stack.destroy
    flash[:notice] = "Removed the tweet from the stack"
    redirect_to tweet_stack_path
  end
end