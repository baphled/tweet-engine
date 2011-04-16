require 'mongoid'

module TweetEngine
  class SearchResult
    include Mongoid::Document
    
    field :screen_name
    field :tweet
  end
end