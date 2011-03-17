Rails.application.routes.draw do
  match '/tweet-stack' => "tweet_stack#index", :as => :tweet_stack
  match '/tweet-stack/search' => "tweet_stack#search", :as => :tweet_search_phrase
end
