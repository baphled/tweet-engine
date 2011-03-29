require 'spec_helper'

describe TweetStack::SearchJob do
  before(:each) do
    @search_job = TweetStack::SearchJob.new
    stub_request(:get, "https://search.twitter.com/search.json?q=rails,%20ruby&rpp=100").
      to_return(:status => 200, :body => fixture('search.json'), :headers => {})
  end
  
  it "should not call search before 15 minutes are up" do
    TweetStack.should_not_receive :search
    Timecop.travel(Time.now + 14.minutes)
    Delayed::Worker.new.work_off
  end
  
  it "should call search every 15 minutes" do
    @search_job.searching
    TweetStack::PotentialFollower.all.count.should == 0
    TweetStack.should_receive :search
    Timecop.travel(Time.now + 15.minutes)
    Delayed::Worker.new.work_off
  end
  
  it "should increase the amount of potential followers" do
    @search_job.searching
    TweetStack::PotentialFollower.all.count.should == 0
    Timecop.travel(Time.now + 15.minutes)
    Delayed::Worker.new.work_off
    TweetStack::PotentialFollower.all.count.should_not == 0
  end
end
