class TweetController < ApplicationController
  
  def create
    TweetStack::Stack.create params[:tweet_stack_stack]
    flash[:notice] = "Added new tweet to the stack"
    redirect_to tweet_stack_path
  end
  
  def edit
    @stack = TweetStack::Stack.find params[:id]
  end
  
  def update
    @stack = TweetStack::Stack.find params[:id]
    @stack.update_attributes params[:tweet_stack_stack]
    flash[:notice] = "Updated the tweet"
    redirect_to tweet_stack_path
  end
  
  def destroy
    stack = TweetStack::Stack.find params[:id]
    stack.destroy
    flash[:notice] = "Removed the tweet from the stack"
    redirect_to tweet_stack_path
  end
end