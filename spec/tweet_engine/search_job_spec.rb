require 'spec_helper'

describe TweetEngine::SearchJob do
  before(:each) do
    stub_request(:get, "https://search.twitter.com/search.json?q=rails,%20ruby").
      to_return(:status => 200, :body => fixture('search.json'), :headers => {})
  end
  
  it "finds the keywords for the search" do
    TweetEngine.config['keywords'].should_not be_empty
  end
  
  it "should do a search" do
    TweetEngine::SearchResult.all.count.should == 0
    TweetEngine.should_receive(:search).and_return []
    TweetEngine::SearchJob.searching 
  end
  
  it "should return a list of screen names for found results" do
    results = ["killermelons", "FelipeNoMore", "Je_eF", "TriceyTrice2U", "eternity4", "twittag", "ArcangelHak", "recycledhumor", "junitaaa", "avexnews", "WildIvory92"]
    TweetEngine::SearchJob.searching.should == results
  end
  
  context "validations" do
    before(:each) do
      TweetEngine::SearchJob.searching
    end
    
    it "should not store screen_names that have aleady been added"
  end
end
