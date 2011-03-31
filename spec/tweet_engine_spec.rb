require 'spec_helper'

describe TweetEngine do
  it "should be valid" do
    TweetEngine.should be_a(Module)
  end
  
  describe "#search" do
    before(:each) do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons&rpp=100").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
    end
    
    it "returns a list of tweeple" do
      data = fixture('search.json')
      TweetEngine.search('lemons').should_not == []
    end
  end
  
  describe "#follow" do
    before(:each) do
      @twitter = Twitter::Client.new
      Twitter::Client.stub(:new).and_return @twitter
      stub_request(:post, "https://api.twitter.com/1/friendships/create.json").
      with(:body => "screen_name=baphled", 
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
      to_return(:status => 200, :body => "", :headers => {})
    end
    
    it "tries uses the twitters API client" do
      Twitter::Client.should_receive :new
      TweetEngine.follow('baphled')
    end
    
    it "follows the user" do
      @twitter.should_receive(:follow).with('baphled')
      TweetEngine.follow('baphled')
    end
  end

  describe "#followers" do
    it "returns the number of followers" do
      stub_request(:get, "https://api.twitter.com/1/statuses/followers.json?cursor=-1").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('followers.json'), :headers => {})
      stub_request(:get, "https://api.twitter.com/1/statuses/followers.json?cursor=1344637399602463196").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('followers2.json'), :headers => {})
      TweetEngine.followers.count.should == 200
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