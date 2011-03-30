require 'delayed_job'
require 'delayed_job_mongoid'

module TweetEngine
  class SearchJob
    
    def searching
      users = TweetEngine.search TweetEngine.config['keywords']
      users_to_add gathered_names(users)
    end
    
    handle_asynchronously :searching
    
    protected
    
    def gathered_names users
      names = []
      all_users = TweetEngine::PotentialFollower.all.to_a
      users.each { |user| names << user.from_user unless all_users.include? user.from_user }
      names
    end
    
    def users_to_add names
      all_users = TweetEngine::PotentialFollower.all.to_a
      names.each do |user|
        TweetEngine::PotentialFollower.create!(:screen_name => user) unless all_users.include? user
      end
    end
  end
end