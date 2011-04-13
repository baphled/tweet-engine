require 'spec_helper'

describe TweetEngine::TweetController do
  before(:each) do
    stub_request(:get, "https://api.twitter.com/1/account/verify_credentials.json").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
    stub_request(:get, "https://api.twitter.com/1/users/show.json?screen_name=pengwynn").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
  end
  describe "POST, create" do
    before(:each) do
      @time = Time.now
      @stack = TweetEngine::Stack.new :message => "This is my tweet", :sending_at => @time
      TweetEngine::Stack.stub(:create).and_return @stack
    end
    
    it "stacks the tweet" do
      TweetEngine::Stack.should_receive(:create).with({"message" => "This is my tweet", "sending_at" => @time})
      post :create, {:tweet_engine_stack => {:message => "This is my tweet", :sending_at => @time}}
    end
  end
end