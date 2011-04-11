require 'mongoid'

module TweetEngine
  class AutoResponse
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
          tweets.each_with_index do |tweet, minutes_from|
            unless item.sent_to.include? tweet.from_user
              TweetEngine::Stack.create! :message => "@#{tweet.from_user} #{item.response}", :sending_at => Time.now + minutes_from.minutes
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
