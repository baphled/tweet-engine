require 'spec_helper'

describe TweetEngine::SearchJob do
  before(:each) do
    @search_job = TweetEngine::SearchJob.new
    TweetEngine.stub!(:search).and_return []
  end
  
  it "finds the keywords for the search" do
    TweetEngine.config['keywords'].should_not be_empty
  end
  
  it "should do a search" do
    TweetEngine::SearchResult.all.count.should == 0
    TweetEngine.should_receive :search
    @search_job.searching 
  end
end
