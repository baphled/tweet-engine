module TweetStack
  require 'tweet_stack/engine' if defined?(Rails)
  require 'tweet_stack/stack' if defined?(Rails)

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
    followers.count
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
    following.count
  end
  
  def self.stack message
    TweetStack::Stack.create :message => message
  end
end