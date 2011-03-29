require 'spec_helper'

describe TweetController do
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