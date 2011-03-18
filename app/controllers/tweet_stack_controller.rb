class TweetStackController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  before_filter :tweet_stack
  before_filter :instantiate_stack
  
  def index
  end
  
  def search
    @results = TweetStack.search params[:q]
    @term = params[:q]
    render :index
  end
  
  def follow
    @new_followers = []
    params[:followers].each do |screen_name|
      @new_followers << TweetStack.follow(screen_name)
    end
    flash[:notice] = "You are now following #{pluralize(@new_followers.count, "more person")}"
    render :index
  end
  
  def stack
    TweetStack.stack params[:message]
    flash[:notice] = "Added new tweet to the stack"
    redirect_to tweet_stack_path
  end
  
  private
  def tweet_stack
    @tweet_stack = TweetStack::Stack.all
  end
  
  def instantiate_stack
    @stack = TweetStack::Stack.new
  end
end