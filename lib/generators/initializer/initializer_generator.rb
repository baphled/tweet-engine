class InitializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)
 
  def copy_initializer_file
    copy_file "initializer.rb", "config/initializers/#{file_name}.rb"
    copy_file "script/tweet_stack_runner", "script/#{file_name}"
    copy_file "config/tweet_stack.yml", "config/#{file_name}.yml"
  end
end