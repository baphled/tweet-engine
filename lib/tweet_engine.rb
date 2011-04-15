require 'twitter'

module TweetEngine
  require 'tweet_engine/engine' if defined?(Rails)
  require 'tweet_engine/base'
  require 'tweet_engine/stack'
  require 'tweet_engine/config'
  require 'tweet_engine/search_job'
  require 'tweet_engine/search_result'
  require 'tweet_engine/responder'
  require 'tweet_engine/runner'
  require 'tweet_engine/auto_respond'
  
  if defined?(Rails::Plugins)
    Merb::Plugins.add_rakefiles File.dirname(__FILE__) / '..' / 'tasks' / 'tasks'
  end
  
end