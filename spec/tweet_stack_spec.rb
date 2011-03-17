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
      TweetStack.follow('baphled')
    end
    
    it "follows the user" do
      @twitter.should_receive(:follow).with('baphled')
      TweetStack.follow('baphled')
    end
  end
end