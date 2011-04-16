require "spec_helper"

describe TweetEngine::EngineController do
  before(:each) do
    stub_request(:get, "https://api.twitter.com/1/account/verify_credentials.json").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
    stub_request(:get, "https://api.twitter.com/1/users/show.json?screen_name=pengwynn").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
  end
  
  describe "GET, index" do
    it "displays the index page" do
      get :index
      response.status.should == 200
    end
    
    it "gets all items in the stack" do
      TweetEngine::Stack.should_receive :paginate
      get :index
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
      TweetEngine.should_receive(:search).with('lemons').and_return []
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
end