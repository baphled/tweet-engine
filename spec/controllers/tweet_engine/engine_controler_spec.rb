require "spec_helper"

describe TweetEngine::EngineController do
  describe "GET, index" do
    it "displays the index page" do
      stub_request(:get, "https://api.twitter.com/1/statuses/followers.json?cursor=-1").
        to_return(:status => 200, :body => fixture('followers2.json'), :headers => {})
      get :index
      response.status.should == 200
    end
  end
  
  describe "GET, search" do
    before(:all) do
      @search = Twitter::Search.new
      Twitter::Search.stub!(:new).and_return @search
    end
    
    before(:each) do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons&rpp=100").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
    end
    it "should do a search via twitter with the search params" do
      TweetEngine.should_receive(:search).with('lemons')
      get :search, {:q => 'lemons'}
    end
  end
  
  describe "POST, follow" do
    before(:each) do
      TweetEngine::SearchResult.create(:screen_name => "baphled")
      TweetEngine::SearchResult.create(:screen_name => "acme_inc")
      stub_request(:post, "https://api.twitter.com/1/friendships/create.json").
        to_return(:status => 200, :body => "", :headers => {})
    end
    it "uses the twitter client" do
      TweetEngine.should_receive(:follow).exactly(2).times
      post :follow, { :followers => { 'baphled' => 'baphled', 'acme_inc' => 'acme_inc' } }
    end
    
    it "removes the users from the potential followers list once they have been followed" do
      TweetEngine::SearchResult.should_receive(:delete_all).exactly(2).times
      post :follow, { :followers => { 'baphled' => 'baphled', 'acme_inc' => 'acme_inc' } }
    end
    
  end
  
  describe "POST, stack" do
    it "stacks the tweet" do
      TweetEngine.should_receive(:stack).with("This is my tweet")
      post :stack, {:message => "This is my tweet"}
    end
  end
  
  describe "GET, followers" do
    before(:each) do
      stub_request(:get, "https://api.twitter.com/1/statuses/friends.json?cursor=-1").
        to_return(:status => 200, :body => "", :headers => {})
    end
    it "makes a call for our follower" do
      TweetEngine.should_receive :following
      get :following
    end
  end

  describe "GET, potential-followers" do
    before(:each) do
      @potential_users = []
      3.times do |amount|
        @potential_users << TweetEngine::SearchResult.create(:screen_name => "Screen name #{amount}")
      end
    end
    
    it "should get a list of all potential followers" do
      TweetEngine::SearchResult.should_receive :all
      get :potential_followers, :followers => @potential_users
    end
  end
end