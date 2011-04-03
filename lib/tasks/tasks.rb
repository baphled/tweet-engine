# Re-definitions are appended to existing tasks

TweetEngine.config = YAML.load_file("#{Rails.root}/config/tweet_engine.yml")[Rails.env]

namespace :tweet_engine do
  desc "Start a tweet_engine and delayed_job daemon."
  task :runner do
    TweetEngine::Runner.djinnify_rails
  end
end