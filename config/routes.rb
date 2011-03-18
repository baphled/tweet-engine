Rails.application.routes.draw do
  match '/tweet-stack' => "tweet_stack#index", :as => :tweet_stack
  match '/tweet-stack/search' => "tweet_stack#search", :as => :tweet_search_phrase
  match '/tweet-stack/follow' => "tweet_stack#follow", :as => :tweet_follow
  match '/tweet-stack/stack' => "tweet_stack#stack", :as => :stack_tweet
  
  resources :tweet, :path => "tweet-stack/tweet"
end
