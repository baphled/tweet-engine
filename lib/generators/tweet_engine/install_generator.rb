module TweetEngine
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      
      def copy_initializer
        template "initializer.rb", "config/initializers/tweet_engine.rb"
      end
      
      def copy_config
        copy_file "config/tweet_engine.yml", "config/tweet_engine.yml"
      end
    end
  end
end
