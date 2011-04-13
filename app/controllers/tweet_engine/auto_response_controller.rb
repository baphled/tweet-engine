class TweetEngine::AutoResponseController < ApplicationController
  before_filter :find_user
  
  
  def new
    @user = TweetEngine.whats_my.user
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
  protected
  
  def find_user
    @user = TweetEngine.whats_my.user
  end
  
end