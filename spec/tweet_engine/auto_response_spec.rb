require 'spec_helper'

describe TweetEngine::AutoResponse do
  it "should have key_phrases" do
    @auto_response = TweetEngine::AutoResponse.new :key_phrases => "Rails, Ruby"
    @auto_response.key_phrases.should_not be_nil
  end
  
  it "stores a response string" do
    @auto_response = TweetEngine::AutoResponse.new :response => "Checkout Rails 3"
    @auto_response.response.should_not be_nil
  end
end
