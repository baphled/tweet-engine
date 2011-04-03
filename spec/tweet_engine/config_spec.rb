require 'spec_helper'

describe TweetEngine do
  before(:each) do
    @config = {
      "keywords"=>"rails, ruby",
      "search"=>true,
      "interval" => 900
    }
    TweetEngine.config = @config
  end
  
  it "should store our config settings" do
    TweetEngine.config.should == @config
  end
  
  it "should store the search keywords" do
    TweetEngine.config['keywords'].should == 'rails, ruby'
  end
  
  it "should store whether we should do searches" do
    TweetEngine.config['search'].should == true
  end
  
  it "should be able to store the interval time for searches" do
    TweetEngine.config['interval'].should == 15.minutes.to_i
  end
end
