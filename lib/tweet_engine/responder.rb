require 'mongoid'

module TweetEngine
  class Responder
    include Mongoid::Document
    field :key_phrases
    field :response
    field :sent_to, :type => Array, :default => []
    
    validates_presence_of :key_phrases, :response
    
    class << self
      def respond
        @users_reponded_to = []
        auto_responses = self.all.to_a
        search_for_respondees auto_responses
        @users_reponded_to
      end
      
      protected
      
      def search_for_respondees auto_responses
        auto_responses.each do |auto_response|
          tweets = TweetEngine.search auto_response.key_phrases
          send_response tweets, auto_response
        end
      end
      
      def send_response tweets, auto_response
        tweets.each do |tweet|
          unless auto_response.sent_to.include? tweet.from_user
            TweetEngine::Stack.create! :message => "@#{tweet.from_user} #{auto_response.response}"
            auto_response.sent_to << tweet.from_user
          end
        end
        auto_response.save
        @users_reponded_to.concat auto_response.sent_to
      end
    end
  end
end
