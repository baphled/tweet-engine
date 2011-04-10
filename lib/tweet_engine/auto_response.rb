require 'mongoid'

module TweetEngine
  class AutoResponse
    include Mongoid::Document
    field :key_phrases
    field :response
  end
end
