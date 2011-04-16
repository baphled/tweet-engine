require 'twitter'

module TweetEngine
  require 'tweet_engine/engine' if defined?(Rails)
  require 'tweet_engine/base'
  require 'tweet_engine/config'
  require 'tweet_engine/search_job'
  
  if defined?(Rails::Plugins)
    Merb::Plugins.add_rakefiles File.dirname(__FILE__) / '..' / 'tasks' / 'tasks'
  end
  
end