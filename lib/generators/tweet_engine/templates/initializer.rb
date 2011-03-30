# Add initialization content here
require 'tweet_engine'

TweetEngine.config = YAML.load_file("#{Rails.root}/config/tweet_engine.yml")[Rails.env]

Twitter.configure do |config|
  config.consumer_key = "CK"
  config.consumer_secret = "CS"
  config.oauth_token = "OT"
  config.oauth_token_secret = "OTS"
end