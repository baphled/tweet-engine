require 'delayed_job'
require 'delayed_job_mongoid'


module TweetEngine
  #
  # A Searching process to help people to find potential followers
  #
  #
  class SearchJob
    class << self
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
        gather_potentials(users)
      end
    
      protected
    
      #
      # Collects a list of potential people to follow
      #
      def gather_potentials users
        names = []
        all_users = []
        TweetEngine::SearchResult.all.to_a.each { |u| all_users << u.screen_name }
        users.each do |user|
          unless all_users.include? user
            TweetEngine::SearchResult.create!(:screen_name => user.from_user, :tweet => user)
            names << user.from_user
          end
        end
        names.uniq!
      end
    end
  end
end