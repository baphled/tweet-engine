require 'spec_helper'

describe TweetEngine::Stack do
  it "has a message" do
    stack = TweetEngine::Stack.new :message => "My message"
    stack.message.should == "My message"
  end
  
  it "should be able to save the message" do
    stack = TweetEngine::Stack.new :message => "My message"
    stack.save.should == true
  end
  
  it "should be able to retrieve a list of all messages" do
    3.times { |int| TweetEngine::Stack.create :message => "My message #{int}"}
    TweetEngine::Stack.all.size.should_not == 0
  end
  
  context "validations" do
    it "must have a message no less than 140 characters"
    it "must have a valid send at date"
  end
  
  describe "#sendable?" do
    before(:each) do
      @tweet = TweetEngine::Stack.new :message => "Some message", :sending_at => Time.now + 1.hour
    end
    
    it "false when the date is not pasted" do
      @tweet.should_not be_sendable
    end
    
    it "true when the date is past the sending_at date" do
      Timecop.freeze(@tweet.sending_at + 1.minute)
      @tweet.should be_sendable
    end
  end
  
  describe "#deliver" do
    context "tweet is scheduled" do
      before(:each) do
        stub_request(:post, "https://api.twitter.com/1/statuses/update.json").to_return(:status => 200, :body => "", :headers => {})
        @tweet = TweetEngine::Stack.create :message => "Some message", :sending_at => Time.now + 1.hour
        @tweet.deliver
        Timecop.travel(@tweet.sending_at + 1.minute)
      end
      
      it "is then set to delivered" do
        Delayed::Worker.new.work_off
        @tweet.reload
        @tweet.delivered.should be_true
      end
      
      it "is not set to delivered is the scheduled time is not up yet" do
        @tweet.deliver
        @tweet.delivered.should be_false
      end
    end
    
    context "tweets that are repeated" do
      before(:each) do
        time = Time.now
        Timecop.freeze(time)
        stub_request(:post, "https://api.twitter.com/1/statuses/update.json").to_return(:status => 200, :body => "", :headers => {})
        @tweet = TweetEngine::Stack.create(
          :message => "Some message",
          :sending_at => Time.now.utc,
          :repeat => true,
          :every => '10 minutes'
        )
        @tweet.deliver
      end
      
      it "should be able to create a new tweet if the on being delivered is set to be repeated" do
        Timecop.travel(@tweet.sending_at + 1.minute)
        Delayed::Worker.new.work_off
        TweetEngine::Stack.where(:message => "Some message").count.should == 2
      end
      
      it "should create a new message that is roughly the right amount of time away from the original" do
        Timecop.travel(@tweet.sending_at)
        Delayed::Worker.new.work_off
        tweet = TweetEngine::Stack.where(:message => "Some message").last
        tweet.sending_at.should == @tweet.sending_at + 10.minutes
      end
    end
  end

  describe "#to_deliver" do
    
    it "returns a list of tweets to send" do
      TweetEngine::Stack.create :message => "Some message", :sending_at => Time.now
      TweetEngine::Stack.to_deliver.count == 1
    end
    
    it "only returns tweets that are equal to the current time" do
      3.times { |i| TweetEngine::Stack.create :message => "Some message #{i}", :sending_at => Time.now - i.to_i.hours }
      TweetEngine::Stack.create :message => "Some message", :sending_at => Time.now
      TweetEngine::Stack.to_deliver.count == 1
    end
  end
end