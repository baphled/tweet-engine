Rails.application.routes.draw do
  namespace 'tweet_engine', :controller => 'engine' do
    match :search
    post :follow
    get :following
    get :followers
    post :unfollow
    get 'potential-followers' => "engine#potential_followers", :as => :potential_followers
    post :stack
    resources :tweet, :except => [:index]
    resources 'auto-response', :controller => :auto_response, :as => :auto_response
  end
  
  match '/tweet-engine' => "tweet_engine/engine#index", :as => :tweet_engine
end
