require "spec_helper"

describe TweetStackController do
  describe "GET, index" do
    it "displays the index page" do
      get :index
      response.status.should == 200
    end
  end
  
  describe "GET, search" do
    before(:all) do
      @search = Twitter::Search.new
      Twitter::Search.stub!(:new).and_return @search
    end
    
    before(:each) do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons&rpp=100").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
    end
    it "should do a search via twitter with the search params" do
      TweetStack.should_receive(:search).with('lemons')
      get :search, {:q => 'lemons'}
    end
  end
end