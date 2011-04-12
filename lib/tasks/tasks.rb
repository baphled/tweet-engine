# Re-definitions are appended to existing tasks

TweetEngine.config = YAML.load_file("#{Rails.root}/config/tweet_engine.yml")[Rails.env]

namespace :tweet_engine do
  desc "Start the search daemon."
  task :runner do
    TweetEngine::Runner.djinnify_rails
  end
  
  desc "Start the auto-response daemon"
  task :auto_respond do
    TweetEngine::AutoRespond.djinnify_rails
  end
end