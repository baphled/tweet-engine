require 'mongoid'

module TweetEngine
  class PotentialFollower
    include Mongoid::Document
    
    field :screen_name
    field :tweet
  end
end