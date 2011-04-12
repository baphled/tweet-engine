require 'mongoid'

module TweetEngine
  class Responder
    include Mongoid::Document
    field :key_phrases
    field :response
    field :sent_to, :type => Array, :default => []
    
    class << self
      def respond
        users_reponded_to = []
        items = self.all.to_a
        items.each do |item|
          tweets = TweetEngine.search item.key_phrases
          tweets.each do |tweet|
            unless item.sent_to.include? tweet.from_user
              TweetEngine::Stack.create! :message => "@#{tweet.from_user} #{item.response}"
              item.sent_to << tweet.from_user
            end
          end
          item.save
          users_reponded_to.concat item.sent_to
        end
        users_reponded_to
      end
    end
  end
end
