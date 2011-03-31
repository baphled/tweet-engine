require 'delayed_job'
require 'delayed_job_mongoid'


module TweetEngine
  #
  # A Searching process to help people to find potential followers
  #
  #
  class SearchJob
    
    #
    # Searches for potential people to follow
    #
    # As this process can take a while we run it in the background.
    #
    # To find potential followers on Twitter we need to run a search periodically
    # to do this we need to run a daemon process that calls searching periodically
    #
    def searching
      users = TweetEngine.search TweetEngine.config['keywords']
      store_search gather_potentials(users)
    end
    
    handle_asynchronously :searching
    
    protected
    
    #
    # Collects a list of potential people to follow
    #
    def gather_potentials users
      names = []
      all_users = TweetEngine::PotentialFollower.all.to_a
      users.each { |user| names << user.from_user unless all_users.include? user.from_user }
      names
    end
    
    #
    # Stores the list of potential followers
    #
    def store_search names
      all_users = TweetEngine::PotentialFollower.all.to_a
      names.each do |user|
        TweetEngine::PotentialFollower.create!(:screen_name => user) unless all_users.include? user
      end
    end
  end
end