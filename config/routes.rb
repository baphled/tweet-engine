Rails.application.routes.draw do
  match '/tweet-stack' => "tweet_stack#index", :as => :tweet_stack
end
