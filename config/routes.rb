Rails.application.routes.draw do
  match '/tweet-engine' => "tweet_engine#index", :as => :tweet_engine
  match '/tweet-engine/search' => "tweet_engine#search", :as => :tweet_search_phrase
  match '/tweet-engine/follow' => "tweet_engine#follow", :as => :tweet_follow
  match '/tweet-engine/following' => "tweet_engine#following", :as => :tweet_engine_following
  match '/tweet-engine/unfollow' => "tweet_engine#unfollow", :as => :tweet_engine_unfollow
  match '/tweet-engine/stack' => "tweet_engine#stack", :as => :stack_tweet
  
  resources :tweet, :path => "tweet-engine/tweet"
end
