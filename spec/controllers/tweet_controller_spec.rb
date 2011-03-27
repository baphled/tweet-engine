require 'spec_helper'

describe TweetController do
  describe "POST, create" do
    before(:each) do
      @time = Time.now
      @stack = TweetStack::Stack.new :message => "This is my tweet", :sending_at => @time
      TweetStack::Stack.stub(:create).and_return @stack
    end
    it "stacks the tweet" do
      TweetStack::Stack.should_receive(:create).with({"message" => "This is my tweet", "sending_at" => @time})
      post :create, {:tweet_stack_stack => {:message => "This is my tweet", :sending_at => @time}}
    end
  end
end