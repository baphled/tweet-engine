module TweetStack
  require 'tweet_stack/engine' if defined?(Rails)
  
  def self.search term
    names = []
    search = Twitter::Search.new
    tweets = search.containing(term).per_page 100
    tweets.each { |tweeple| names << tweeple.from_user }
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
end