module TweetStack
  class Stack
    include Mongoid::Document
  
    field :message
  end
end