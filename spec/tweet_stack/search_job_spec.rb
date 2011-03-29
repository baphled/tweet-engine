require 'spec_helper'

describe TweetStack::SearchJob do
  before(:each) do
    @search_job = TweetStack::SearchJob.new
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
  
  it "should call search twice after 30 minutes" do
    @search_job.searching
    TweetStack::PotentialFollower.all.count.should == 0
    TweetStack.should_receive(:search).exactly(2).times
    Timecop.travel(Time.now + 30.minutes)
    Delayed::Worker.new.work_off
  end
end
