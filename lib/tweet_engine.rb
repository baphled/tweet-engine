require 'twitter'

module TweetEngine
  require 'tweet_engine/engine' if defined?(Rails)
  require 'tweet_engine/stack'
  require 'tweet_engine/config'
  require 'tweet_engine/search_job'
  require 'tweet_engine/potential_follower'
  require 'tweet_engine/search_result'
  
  class << self
    #
    # Wrapper for Twitter::CLient
    #
    # Basically some syntactic sugar to make calls to the client read cleanly
    #
    # This gives us full access to the twitter client API instead of creating duplicating functionality already tested
    # some where else
    #
    def whats_my
      Twitter::Client.new
    end
  
    def search term
      names = []
      search = Twitter::Search.new
      tweets = search.containing(term).per_page 100
      tweets.each { |tweeple| names << tweeple }
      names
    end
  
    def follow screen_name
      Twitter.follow screen_name
    end
  
    #
    # Wrapper method to get a list of all followers instead of getting the page by page
    #
    #
    def followers
      followers = []
      cursor_id = -1
      while cursor_id != 0
        tweeple = Twitter.followers :cursor => cursor_id
        tweeple.users.each { |person| followers << person }
        cursor_id = tweeple.next_cursor
      end
      followers
    end
  
    def following
      following = []
      cursor_id = -1
      while cursor_id != 0
        tweeple = Twitter.friends :cursor => cursor_id
        tweeple.users.each { |person| following << person }
        cursor_id = tweeple.next_cursor
      end
      following
    end
  
    def stack message
      TweetEngine::Stack.create :message => message
    end
  end
end