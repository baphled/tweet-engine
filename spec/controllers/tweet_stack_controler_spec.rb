require "spec_helper"

describe TweetStackController do
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
      TweetStack.should_receive(:search).with('lemons')
      get :search, {:q => 'lemons'}
    end
  end
  
  describe "POST, follow" do
    it "uses the twitter client" do
      TweetStack.should_receive(:follow).exactly(2).times
      post :follow, { :followers => { 'baphled' => 'baphled', 'acme_inc' => 'acme_inc' } }
    end
  end
  
  describe "POST, stack" do
    it "stacks the tweet" do
      TweetStack.should_receive(:stack).with("This is my tweet")
      post :stack, {:message => "This is my tweet"}
    end
  end
  
  describe "GET, followers" do
    before(:each) do
      stub_request(:get, "https://api.twitter.com/1/statuses/friends.json?cursor=-1").
        to_return(:status => 200, :body => "", :headers => {})
    end
    it "makes a call for our follower" do
      TweetStack.should_receive :following
      get :following
    end
  end
end