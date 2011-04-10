class TweetEngine::AutoResponseController < ApplicationController
  
  def new
    @auto_response = TweetEngine::AutoResponse.new
  end
  
  def create
    @auto_response = TweetEngine::AutoResponse.new params[:tweet_engine_auto_response]
    if @auto_response.save
      flash[:notice] = 'Added new auto-response'
      redirect_to tweet_engine_path
    else
      render :new
    end
  end
end