require "spec_helper"

describe TweetEngine::PotentialFollowersController do
  before(:each) do
    stub_request(:get, "https://api.twitter.com/1/account/verify_credentials.json").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
    stub_request(:get, "https://api.twitter.com/1/users/show.json?screen_name=pengwynn").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
  end
  
  describe "GET, potential-followers" do
    before(:each) do
      @potential_users = []
      3.times do |amount|
        @potential_users << TweetEngine::SearchResult.create(:screen_name => "Screen name #{amount}")
      end
    end
    
    it "should get a list of all potential followers" do
      TweetEngine::SearchResult.should_receive(:paginate).exactly(2).times
      get :index
    end
  end

end