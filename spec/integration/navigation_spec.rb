require 'spec_helper'

describe "Navigation" do
  include Capybara
  
  before(:each) do
    TweetStack.stub!(:followers).and_return 10
    TweetStack.stub!(:following).and_return 20
    TweetStack::Stack.destroy_all
  end
  
  it "should be a valid app" do
    ::Rails.application.should be_a(Dummy::Application)
  end
  
  it "should let me view tweet stack" do
    visit "/tweet-stack"
    page.should have_content "Tweet stack"
    
    page.should have_content "You currently have 10 followers"
    page.should have_content "You are following 20 tweeple"
  end
  
  context "searching for tweeple" do
    it "should let me do a search based on a phrase" do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons&rpp=100").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
      visit "/tweet-stack"
      page.should_not have_content "Tweeple talking about 'lemons':"
      fill_in "Search for:", :with => "lemons"
      click_button "Search"
      page.should have_content "Tweeple talking about 'lemons':"
    end
  
    it "allows me to follow a batch of tweeples" do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons&rpp=100").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
      
      stub_request(:post, "https://api.twitter.com/1/friendships/create.json").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => "", :headers => {})
      
      visit "/tweet-stack"
      fill_in "Search for:", :with => "lemons"
      click_button "Search"
    
      #select all tweeple found
      check "killermelons"
      # press follow
      click_button "Follow"
    
      # should see a list of users that I am now following
      page.should have_content "You are now following 1 more person"
    end
  end
  
  context "stacking tweets" do
    it "it alls me to stack up tweets" do
      visit "/tweet-stack"
    
      fill_in "Enter Tweet", :with => "This is my new tweet"
      click_button "Stack Tweet"
    
      page.should have_content "Added new tweet to the stack"
      page.should have_content "Stacked tweets"
      page.should have_content "This is my new tweet"
    
    end
  
    it "allows me to manage a tweet" do
      # I create a tweet
      visit "/tweet-stack"
    
      fill_in "Enter Tweet", :with => "This is my new tweet"
      click_button "Stack Tweet"
    
      page.should have_content "Added new tweet to the stack"
    
      # I manage the tweet
      click_link 'Edit'
    
      # I change the message
      fill_in "Message", :with => "My changed tweet"
    
      # I change when it is sent out
      fill_in "Send at", :with => "3000-12-12"
      click_button 'Stack Tweet'
    
      # I should see the change
      page.should have_content "Updated the tweet"
    end
  end
  
  context "sending out tweets" do
    before(:each) do
      stub_request(:post, "https://api.twitter.com/1/statuses/update.json").
        to_return(:status => 200, :body => "", :headers => {})
    end
    
    it "should send out a tweet that has pasted its scheduled delivery time" do
      # I create a schedule tweet
      tweet = TweetStack::Stack.create! :message => "My message", :send_at => DateTime.current + 1.hour
    
      # The scheduled time passes
      Timecop.freeze(tweet.send_at)
      tweet.send_at.should eql DateTime.current
      # I should get a message stating the tweet has been sent
      tweet.deliver
    
      tweet.delivered.should be_true
    
      # I should not see the tweet in the stack
      visit "/tweet-stack"
      page.should have_content "My message - Sent"
    end
  
    it "should not send out a tweet that has been scheduled but that time has not gone by yet" do
      # I create a schedule tweet
      tweet = TweetStack::Stack.create! :message => "My message", :send_at => DateTime.current + 1.hour
      
      # I should get a message stating the tweet has been sent
      tweet.deliver
      
      tweet.delivered.should be_false
      
      # I should not see the tweet in the stack
      visit "/tweet-stack"
      page.should_not have_content "My message - Sent"
    end
  end
  
  it "displays a list of recent followers that I am following"
  it "allows me to unfollow people I am following"
  it "should be able to store a the found tweeple for later"
  
  context "intelligent tweeting" do
    it "auto responds to people who mention one of our key phrases"
    it "allows us to send out a tweet depending on peoples comments"
    
  end
  context "settings" do
    it "allows me to set a tweet interval" do
      pending 'Add implementation later'
      # i go to the setting page
      # I fill in the default interval
      # I go to the tweet stack
      # I create a new tweet
      # The tweet should display a when it will be sent out
    end
    it "allows me to manage the amount of tweeple I can follow a day"
    it "allows me to manage the amount of tweets I send out a day"
  end
end
