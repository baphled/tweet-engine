module TweetEngine
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)
      
      def copy_initializer
        template "initializer.rb", "config/initializers/#{file_name}.rb"
      end
      
      def copy_script
        copy_file "script/tweet_engine_runner", "script/#{file_name}"
      end
      
      def copy_config
        copy_file "config/tweet_engine.yml", "config/#{file_name}.yml"
      end
    end
  end
end
