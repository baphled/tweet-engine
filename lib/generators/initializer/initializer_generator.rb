class InitializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)
  
  gem 'mongoid', :git => "https://github.com/mongoid/mongoid.git"
  gem 'bson_ext'
  gem 'simple_form'
  gem 'jquery-rails', '>= 0.2.6'
  gem 'delayed_job', '>= 2.1.4', :git => "https://github.com/collectiveidea/delayed_job"
  gem 'delayed_job_mongoid', :git => "https://github.com/collectiveidea/delayed_job_mongoid.git"
  gem 'djinn'
  
  def copy_initializer_file
    copy_file "initializer.rb", "config/initializers/#{file_name}.rb"
    copy_file "script/tweet_engine_runner", "script/#{file_name}"
    copy_file "config/tweet_engine.yml", "config/#{file_name}.yml"
  end
end