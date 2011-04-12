class TweetEngine::AutoResponseController < ApplicationController
  
  def new
    @auto_response = TweetEngine::Responder.new
  end
  
  def create
    @auto_response = TweetEngine::Responder.new params[:tweet_engine_responder]
    if @auto_response.save
      flash[:notice] = 'Added new auto-response'
      redirect_to tweet_engine_path
    else
      render :new
    end
  end
  
  def edit
    @auto_response = TweetEngine::Responder.find params[:id]
  end
end