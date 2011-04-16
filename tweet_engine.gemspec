# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "tweet_engine"
  s.platform = Gem::Platform::RUBY
  s.summary = "Add a tweet engine to your app."
  s.description = "Allows you to easily manage tweets and followers via an control panel."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.4"
  
  s.add_dependency('twitter')
  s.add_dependency('mongoid')
  s.add_dependency('bson_ext')
  s.add_dependency('delayed_job')
  s.add_dependency('delayed_job_mongoid')
  s.add_dependency('djinn')
  s.add_dependency('devise')
  s.add_dependency('date_validator')
end