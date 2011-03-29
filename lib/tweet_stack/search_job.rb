module TweetStack
  class SearchJob
    
    def searching
      names = []
      users = TweetStack.search TweetStack.config['keywords']
      gather_results users
      users_to_add names
    end
    
    protected
    
    def gather_results
      all_users = TweetStack::PotentialFollower.all.to_a
      users.each { |user| names << user.from_user unless all_users.include? user.from_user }
      names.uniq!
    end
    
    def users_to_add names
      names.each do |user|
        TweetStack::PotentialFollower.create!(:screen_name => user) unless all_users.include? user
      end
    end
    handle_asynchronously :searching, :run_at => (Time.now + 1.minutes)
  end
end