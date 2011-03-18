require 'spec_helper'

describe TweetController do
  describe "POST, create" do
    it "stacks the tweet" do
      TweetStack.should_receive(:stack).with("This is my tweet")
      post :create, {:message => "This is my tweet"}
    end
  end
end