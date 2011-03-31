require 'spec_helper'

describe "Navigation" do
  include Capybara
  
  before(:each) do
    stub_request(:get, "https://api.twitter.com/1/account/verify_credentials.json").
      to_return(:status => 200, :body => fixture('user.json'), :headers => {})
    stub_request(:get, "https://api.twitter.com/1/users/show.json?screen_name=pengwynn").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
    TweetEngine::Stack.destroy_all
  end
  
  it "should be a valid app" do
    ::Rails.application.should be_a(Dummy::Application)
  end
  
  context "User information and statistics" do
    it "should let me view tweet stack" do
      visit "/tweet-engine"
      page.should have_content "You currently have 3199 followers"
      page.should have_content "You are following 2106 tweeple"
    end
  end
  
  context "searching for tweeple" do
    it "should let me do a search based on a phrase" do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons&rpp=100").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
      visit "/tweet-engine"
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
      
      visit "/tweet-engine"
      fill_in "Search for:", :with => "lemons"
      click_button "Search"
    
      #select all tweeple found
      check "killermelons"
      # press follow
      click_button "Follow"
    
      # should see a list of users that I am now following
      page.should have_content "You are now following 1 more person"
    end
  
    it "updates my list of potential followers on 15 minute interval" do
      pending 'Not quite sure how to test this'
      
      # run djinn
      run "#{Rails.root}/script/tweet_stack_runner start"
      
      # we have keywords we want to follow tweeple based on
      tweeple_found = TweetEngine::PotentialFollower.all.to_a
      tweeple_found.should_not be_empty
      
      TweetEngine.config['keywords'].should == 'rails, ruby'
      TweetEngine.config['search'].should == true
      Timecop.travel(Time.now + 15.minutes)
      tweeple_found.should_not == TweetEngine::PotentialFollower.all.to_a
      run '#{Rails.root}/script/tweet_stack_runner --stop'
    end
    
  end
  
  context "stacking tweets" do
    it "it allows me to stack up tweets" do
      visit "/tweet-engine"
    
      fill_in "Enter Tweet", :with => "This is my new tweet"
      click_button "Stack Tweet"
    
      page.should have_content "Added new tweet to the stack"
      page.should have_content "Stacked tweets"
      page.should have_content "This is my new tweet"
    
    end
  
    it "allows me to manage a tweet" do
      # I create a tweet
      visit "/tweet-engine"
    
      fill_in "Enter Tweet", :with => "This is my new tweet"
      click_button "Stack Tweet"
    
      page.should have_content "Added new tweet to the stack"
    
      # I manage the tweet
      click_link 'Edit'
    
      # I change the message
      fill_in "Message", :with => "My changed tweet"
    
      # I change when it is sent out
      fill_in "Sending at", :with => "3000-12-12"
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
      tweet = TweetEngine::Stack.create! :message => "My message", :sending_at => Time.now + 2.hour
      tweet.deliver
      # The scheduled time passes
      Timecop.travel(tweet.sending_at)
      
      # Delayed jobs are run
      Delayed::Worker.new.work_off
      
      # I should get a message stating the tweet has been sent
      visit "/tweet-engine"
      page.should have_content "My message - Sent"
    end
    
    it "should not send out a tweet that has been scheduled but that time has not gone by yet" do
      # I create a schedule tweet
      tweet = TweetEngine::Stack.create! :message => "My message", :sending_at => Time.now + 1.hour
      tweet.deliver
      Delayed::Worker.new.work_off
      # I should get a message stating the tweet has been sent
      tweet.delivered.should be_false
      
      # I should not see the tweet in the stack
      visit "/tweet-engine"
      page.should_not have_content "My message - Sent"
    end
  
    it "does not send out tweet if they are not ready to be sent out yet" do
      tweet = TweetEngine::Stack.create! :message => "My message", :sending_at => Time.now + 1.hour
      tweet.deliver
      Delayed::Worker.new.work_off
      
      tweet.delivered.should be_false
      
      # I should not see the tweet in the stack
      visit "/tweet-engine"
      page.should_not have_content "My message - Sent"
    end
  end
  
  it "allows me to unfollow people I am following" do
    stub_request(:get, "https://api.twitter.com/1/statuses/friends.json?cursor=-1").
      to_return(:status => 200, :body => fixture('friends.json'), :headers => {})
    stub_request(:delete, "https://api.twitter.com/1/friendships/destroy.json?screen_name=timoreilly").
      to_return(:status => 200, :body => "", :headers => {})
    # visit the stack
    visit "/tweet-engine"
    
    click_link "Followers"
    # follow the unfollow link
    click_button 'Unfollow'
    
    # I should see a list of people I am following
    page.should have_content "Unfollowing timoreilly"
  end
  
  it "should be able to follower tweeple I have found"
  it "displays a list of recent followers that I am following"
  
  context "intelligent tweeting" do
    it "auto responds to people who mention one of our key phrases"
    it "allows us to send out a tweet depending on peoples comments"
  end
  
  context "settings" do
    it "allows me to set a tweet interval" do
      pending 'Add implementation later'
      # i go to the setting page
      visit '/tweet-engine/settings'
      # I fill in the default interval
      fill_in 'Auto-tweet interval', :with => "10 mins"
      
      # I go to the tweet stack
      click_button "Update Settings"
      
      # I set up a tweet with no date
      TweetEngine::Stack.create :message => 'A new message'
      
      # 10 mins go by
      Timecop.travel 10.mins
      
      # My tweet is sent
      TweetEngine::Stack.last.should be_delivered
    end
    
    it "allows me to set my auto search interval"
    it "allows me to manage the amount of tweeple I can follow a day"
    it "allows me to manage the amount of tweets I send out a day"
    it "allows me to set a average search time"
  end
end
