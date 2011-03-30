# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "tweet_engine"
  s.platform = Gem::Platform::RUBY
  s.summary = "Insert TweetEngine summary."
  s.description = "Insert TweetEngine description."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.1"
  
  s.add_dependency('twitter')
  s.add_dependency('mongoid')
  s.add_dependency('bson_ext')
  s.add_dependency('simple_form')
  s.add_dependency('delayed_job')
  s.add_dependency('delayed_job_mongoid')
  s.add_dependency('djinn')
end