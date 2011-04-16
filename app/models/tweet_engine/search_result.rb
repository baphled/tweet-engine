require 'mongoid'

module TweetEngine
  class SearchResult
    include Mongoid::Document
    
    field :screen_name
    field :tweet
    
    validates_uniqueness_of :screen_name, :tweet
  end
end