require 'spec_helper'

describe TweetController do
  describe "POST, create" do
    it "stacks the tweet" do
      TweetStack::Stack.should_receive(:create).with({"message" => "This is my tweet"})
      post :create, {:tweet_stack_stack => {:message => "This is my tweet"}}
    end
  end
end