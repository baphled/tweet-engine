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
end