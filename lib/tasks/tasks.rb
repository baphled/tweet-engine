# Re-definitions are appended to existing tasks

TweetEngine.config = YAML.load_file("#{Rails.root}/config/tweet_engine.yml")[Rails.env]

namespace :tweet_engine do
  desc "Start a tweet_engine and delayed_job daemon."
  task :runner do
    TweetEngine::Runner.djinnify_rails
    Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY']).start
  end
end