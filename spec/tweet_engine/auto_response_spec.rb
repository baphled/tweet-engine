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
  
  describe "#respond" do
    before(:each) do
      @auto_response = TweetEngine::AutoResponse.create! :key_phrases => "Twitter", :response => "Twitter is cool"
      stub_request(:get, "https://search.twitter.com/search.json?q=Twitter&rpp=100").
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
    end
    
    it "gets all the auto-response" do
      TweetEngine::AutoResponse.should_receive :all
      TweetEngine::AutoResponse.respond
    end
    
    it "sends the response to each unique person found" do
      TweetEngine.should_receive(:stack).exactly(11).times
      TweetEngine::AutoResponse.respond
    end
    
    it "returns a list of screen_names for people it sent replies to" do
      users = ["killermelons", "FelipeNoMore", "Je_eF", "TriceyTrice2U", "eternity4", "twittag", "ArcangelHak", "recycledhumor", "junitaaa", "avexnews", "WildIvory92"]
      result = TweetEngine::AutoResponse.respond
      @auto_response.reload
      @auto_response.sent_to.should eql users
      result.should eql users
    end
  end
end
