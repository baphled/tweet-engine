require 'spec_helper'

describe TweetStack::Stack do
  it "has a message" do
    stack = TweetStack::Stack.new :message => "My message"
    stack.message.should == "My message"
  end
  
  it "should be able to save the message" do
    stack = TweetStack::Stack.new :message => "My message"
    stack.save.should == true
  end
  
  it "should be able to retrieve a list of all messages" do
    3.times { |int| TweetStack::Stack.create :message => "My message #{int}"}
    TweetStack::Stack.all.size.should_not == 0
  end
  
  context "validations" do
    it "must have a message no less than 140 characters"
    it "must have a valid send at date"
  end
  
  describe "#scheduled?" do
    before(:each) do
      @tweet = TweetStack::Stack.new :message => "Some message", :send_at => DateTime.current + 1.hour
    end
    
    it "false when the date is not pasted" do
      @tweet.should_not be_scheduled
    end
    
    it "true when the date is past the send_at date" do
      Timecop.freeze(@tweet.send_at + 1.minute)
      @tweet.should be_scheduled
    end
  end
  
  describe "#deliver" do
    before(:each) do
      @tweet = TweetStack::Stack.create :message => "Some message", :send_at => DateTime.current + 1.hour
    end
    
    context "tweet is scheduled" do
      before(:each) do
        Timecop.freeze(@tweet.send_at + 1.minute)
        @tweet.stub(:scheduled?).and_return true
      end
      
      it "sends the tweet" do
        Twitter.should_receive :update
        @tweet.deliver
      end
      
      it "is then set to delivered" do
        stub_request(:post, "https://api.twitter.com/1/statuses/update.json").to_return(:status => 200, :body => "", :headers => {})
        @tweet.deliver
        @tweet.delivered.should be_true
      end
    end
    
    context "tweet that is not supposed to be sent out yet" do
      it "is not set to delivered is the scheduled time is not up yet" do
        stub_request(:post, "https://api.twitter.com/1/statuses/update.json").to_return(:status => 200, :body => "", :headers => {})
        @tweet.deliver
        @tweet.delivered.should be_false
      end
    end
  end
end