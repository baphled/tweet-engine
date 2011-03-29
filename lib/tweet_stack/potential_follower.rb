module TweetStack
  class PotentialFollower
    include Mongoid::Document
    
    field :screen_name
  end
end