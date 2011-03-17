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
end