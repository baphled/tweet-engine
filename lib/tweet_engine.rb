module TweetEngine
  require 'tweet_engine/engine' if defined?(Rails)
  require 'tweet_engine/stack'
  require 'tweet_engine/config'
  require 'tweet_engine/search_job'
  require 'tweet_engine/potential_follower'
    
  def self.search term
    names = []
    search = Twitter::Search.new
    tweets = search.containing(term).per_page 100
    tweets.each { |tweeple| names << tweeple }
    names
  end
  
  def self.follow screen_name
    client = Twitter::Client.new
    client.follow screen_name
  end
  
  def self.followers
    client = Twitter::Client.new
    followers = []
    cursor_id = -1
    while cursor_id != 0
      tweeple = client.followers :cursor => cursor_id
      tweeple.users.each { |person| followers << person.screen_name }
      cursor_id = tweeple.next_cursor
    end
    followers
  end
  
  def self.following
    client = Twitter::Client.new
    following = []
    cursor_id = -1
    while cursor_id != 0
      tweeple = client.friends :cursor => cursor_id
      tweeple.users.each { |person| following << person.screen_name }
      cursor_id = tweeple.next_cursor
    end
    following
  end
  
  def self.stack message
    TweetEngine::Stack.create :message => message
  end
end