Rails.application.routes.draw do
  authenticate "admin" do 
    resource 'tweet-engine', :controller => 'tweet_engine/engine', :as => :tweet_engine, :only => [:index] do
      get :search
      post :follow
      get :following
      get :followers
      post :unfollow
      post :stack
      resources :tweet, :except => [:index], :controller => "tweet_engine/tweet"
      resources 'auto-response', :controller => "tweet_engine/auto_response", :as => :auto_response
      resources 'potential-followers', :controller => 'tweet_engine/potential_followers', :as => :potential_followers, :except => [:show]
    end
  
    match '/tweet-engine' => "tweet_engine/engine#index", :as => :tweet_engine
  end
end
