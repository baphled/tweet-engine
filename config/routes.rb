Rails.application.routes.draw do
  namespace 'tweet_engine', :controller => 'engine' do
    match :search
    post :follow
    get :following
    get :followers
    post :unfollow
    get 'potential-followers' => "engine#potential_followers", :as => :potential_followers
    post :stack
    resource :tweet, :except => [:index]
  end
  
  match '/tweet-engine' => "tweet_engine/engine#index", :as => :tweet_engine
  # match '/tweet-engine/search' => "tweet_engine#search", :as => :tweet_search_phrase
  # match '/tweet-engine/follow' => "tweet_engine#follow", :as => :tweet_follow
  # match '/tweet-engine/following' => "tweet_engine#following", :as => :tweet_engine_following
  # match '/tweet-engine/followers' => "tweet_engine#followers", :as => :tweet_engine_followers
  # match '/tweet-engine/unfollow' => "tweet_engine#unfollow", :as => :tweet_engine_unfollow
  # match '/tweet-engine/potential-followers' => "tweet_engine#potential_followers", :as => :tweet_engine_potential_followers
  # match '/tweet-engine/stack' => "tweet_engine#stack", :as => :stack_tweet
  # 
  # resources :tweet, :path => "tweet-engine/tweet"
end
