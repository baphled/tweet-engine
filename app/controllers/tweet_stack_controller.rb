require 'twitter'
class TweetStackController < ApplicationController
  include ActionView::Helpers::TextHelper
  
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
end