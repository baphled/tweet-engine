require 'spec_helper'

describe TweetEngine::Runner do
  it "instantiate a new object" do
    TweetEngine::Runner.new.should_not be_nil
  end
end
