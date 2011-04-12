require 'spec_helper'

describe TweetEngine do
  it "should be valid" do
    TweetEngine.should be_a(Module)
  end
  
  describe "#search" do
    before(:each) do
    end
    
    it "returns a list of tweeple" do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons&rpp=100").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
      data = fixture('search.json')
      TweetEngine.search('lemons', 100).should_not == []
    end
    
    it "uses the default value if no amount is given" do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
      data = fixture('search.json')
      TweetEngine.search('lemons').should_not == []
    end
  end
  
  describe "#follow" do
    before(:each) do
      stub_request(:post, "https://api.twitter.com/1/friendships/create.json").
      with(:body => "screen_name=baphled", 
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
      to_return(:status => 200, :body => "", :headers => {})
    end
    
    it "follows the user" do
      Twitter.should_receive(:follow).with('baphled')
      TweetEngine.follow('baphled')
    end
  end

  describe "#following" do
    before(:each) do
      stub_request(:get, "https://api.twitter.com/1/statuses/friends.json?cursor=-1").
        to_return(:status => 200, :body => fixture('followers.json'), :headers => {})
      stub_request(:get, "https://api.twitter.com/1/statuses/friends.json?cursor=-1").
        to_return(:status => 200, :body => fixture('followers2.json'), :headers => {})
    end
    
    it "returns an array" do
      TweetEngine.following.should be_an Array
    end
    
    it "should contain the users screen_name" do
      TweetEngine.following.first.should respond_to :screen_name
    end
  end
  
  describe "#followers" do
    before(:each) do
      stub_request(:get, "https://api.twitter.com/1/statuses/followers.json?cursor=-1").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('followers.json'), :headers => {})
      stub_request(:get, "https://api.twitter.com/1/statuses/followers.json?cursor=1344637399602463196").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('followers2.json'), :headers => {})
    end
    it "returns the number of followers" do
      TweetEngine.followers.count.should == 200
    end
    
    it "should contain the users screen_name" do
      TweetEngine.followers.first.should respond_to :screen_name
    end
  end
  
  describe "#stack" do
    it "should add the tweet to the stack" do
      TweetEngine::Stack.should_receive(:create).with(:message => "This is my tweet")
      TweetEngine.stack("This is my tweet")
    end
  end
  
  describe "#whats_my" do
    before(:each) do
      stub_request(:get, "https://api.twitter.com/1/account/verify_credentials.json").
        to_return(:status => 200, :body => fixture('user.json'), :headers => {})
      stub_request(:get, "https://api.twitter.com/1/users/show.json?screen_name=pengwynn").
        to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
    end
    
    it "is a wrapper for Twitter::Client" do
      TweetEngine.whats_my.should be_a Twitter::Client
    end
    
    it "has access to my user information" do
      TweetEngine.whats_my.user.screen_name.should == 'pengwynn'
    end
    
    it "stores my last tweet" do
      TweetEngine.whats_my.user.status.text.should == '{{! Mustache Playground }} from @pvande http://wynn.fm/ce'
    end
    
    it "has access to my friends" do
      TweetEngine.whats_my.user.friends_count.should == 2106
    end
    
    it "has access to my followers" do
      TweetEngine.whats_my.user.followers_count.should == 3199
    end
  end
end