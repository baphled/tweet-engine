module TweetStack
  class Stack
    include Mongoid::Document
  
    field :message
    field :send_at, :type => Date
  end
end