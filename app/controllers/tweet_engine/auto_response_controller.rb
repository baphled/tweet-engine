class TweetEngine::AutoResponseController < TweetEngineController
  
  def index
    @auto_responses = TweetEngine::Responder.all
  end
  
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
  
  def update
    @auto_response = TweetEngine::Responder.find params[:id]
    if @auto_response.update_attributes params[:tweet_engine_responder]
      flash[:notice] = 'Updated auto-response'
      redirect_to tweet_engine_path
    else
      render :edit
    end
  end
end