Rails.application.routes.draw do
  namespace 'tweet_engine', :controller => 'engine' do
    match :search
    post :follow
    get :following
    get :followers
    post :unfollow
    post :stack
    resources :tweet, :except => [:index]
    resources 'auto-response', :controller => :auto_response, :as => :auto_response
    resources 'potential-followers', :controller => :potential_followers, :as => :potential_followers, :except => [:show]
  end
  
  match '/tweet-engine' => "tweet_engine/engine#index", :as => :tweet_engine
end
