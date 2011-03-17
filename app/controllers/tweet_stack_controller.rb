require 'twitter'
class TweetStackController < ApplicationController
  def index
    
  end
  
  def search
    @results = TweetStack.search params[:q]
    @term = params[:q]
    render :index
  end
end