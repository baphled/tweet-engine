require 'spec_helper'

describe TweetStack do
  it "should be valid" do
    TweetStack.should be_a(Module)
  end
  
  
  describe "#search" do
    before(:each) do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons&rpp=100").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
    end
    
    it "returns a list of tweeple" do
      TweetStack.search('lemons').should == ["killermelons", "FelipeNoMore", "Je_eF", "TriceyTrice2U", "eternity4", "twittag", "twittag", "twittag", "ArcangelHak", "recycledhumor", "junitaaa", "twittag", "avexnews", "WildIvory92", "twittag"]
    end
  end
end