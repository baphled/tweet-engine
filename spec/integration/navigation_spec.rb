require 'spec_helper'

describe "Navigation" do
  include Capybara
  
  before(:each) do
    stub_request(:get, "https://api.twitter.com/1/account/verify_credentials.json").
      to_return(:status => 200, :body => fixture('user.json'), :headers => {})
    stub_request(:get, "https://api.twitter.com/1/users/show.json?screen_name=pengwynn").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
    TweetEngine::Stack.destroy_all
    
    @admin = Admin.create!(:username => Faker::Name.first_name, :email => Faker::Internet.email, :password => 'foobar')
    visit '/admins/sign_in'
    
    find("input#admin_email").set @admin.email
    find("input#admin_password").set @admin.password
    
    click_button 'Sign in'
  end
  
  it "should be a valid app" do
    ::Rails.application.should be_a(Dummy::Application)
  end
  
  context "User information and statistics" do
    before(:each) do
      visit "/tweet-engine"
    end
    
    it "displays my name" do
      page.should have_content "Using twitter account:"
      page.should have_content "pengwynn"
    end
    
    it "displays my last update" do
      page.should have_content "{{! Mustache Playground }} from @pvande http://wynn.fm/ce"
    end
    
    it "number of lists I am part of"
    it "displays my description"
    
    it "displays the the total amount of followers" do
      page.should have_content "You currently have 3199 followers"
    end
    
    it "displays the the total amount of people I am following" do
      page.should have_content "You are following 2106 tweeple"
    end
    
    it "should be able to get an avg of new followers per week"
    it "should display the avg amount of tweet your send out a day"
    it "should display the avg amount of tweet your send out a week"
    it "should display the avg amount of tweet your send out a month"
  end
  
  context "searching for tweeple" do
    it "should let me do a search based on a phrase" do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
      visit "/tweet-engine"
      page.should_not have_content "Tweeple talking about 'lemons':"
      find('.searchbox').set('lemons')
      # fill_in :q, :with => "lemons"
      click_button "Search"
      
      page.should have_content "Tweeple talking about 'lemons'"
    end
  
    it "allows me to follow a batch of tweeples" do
      stub_request(:get, "https://search.twitter.com/search.json?q=lemons").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => fixture('search.json'), :headers => {})
      
      stub_request(:post, "https://api.twitter.com/1/friendships/create.json").
        with(:headers => {'Accept'=>'application/json', 'User-Agent'=>'Twitter Ruby Gem 1.1.2'}).
        to_return(:status => 200, :body => "", :headers => {})
      
      visit "/tweet-engine"
      
      find('.searchbox').visible?
      find('.searchbox').set('lemons')
      # fill_in :q, :with => "lemons"
      click_button "Search"
      
      #select all tweeple found
      check "followers_0"
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
      tweeple_found = TweetEngine::SearchResult.all.to_a
      tweeple_found.should_not be_empty
      
      TweetEngine.config['keywords'].should == 'rails, ruby'
      TweetEngine.config['search'].should == true
      Timecop.travel(Time.now + 15.minutes)
      tweeple_found.should_not == TweetEngine::SearchResult.all.to_a
      run '#{Rails.root}/script/tweet_stack_runner --stop'
    end
    
  end
  
  context "stacking tweets" do
    it "it allows me to stack up tweets" do
      visit "/tweet-engine"
    
      fill_in "Enter Tweet", :with => "This is my new tweet"
      click_button "Stack Tweet"
      
      page.should have_content "Added new tweet to the stack"
      page.should have_content "Stacked Tweets"
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
      fill_in "Enter Tweet", :with => "My changed tweet"
    
      # I change when it is sent out
      fill_in "Sending At", :with => "3000-12-12"
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
      # The scheduled time passes
      Timecop.travel(tweet.sending_at)
      
      # Delayed jobs are run
      Delayed::Worker.new.work_off
      
      # I should get a message stating the tweet has been sent
      visit "/tweet-engine"
      
      page.should have_content "My message"
      page.should have_content "this was sent at less than a minute"
    end
    
    it "should not send out a tweet that has been scheduled but that time has not gone by yet" do
      # I create a schedule tweet
      tweet = TweetEngine::Stack.create! :message => "My message", :sending_at => Time.now + 1.hour

      Delayed::Worker.new.work_off
      # I should get a message stating the tweet has been sent
      tweet.delivered.should be_false
      
      # I should not see the tweet in the stack
      visit "/tweet-engine"
      page.should_not have_content "My message - Sent"
    end
  
    it "does not send out tweet if they are not ready to be sent out yet" do
      tweet = TweetEngine::Stack.create! :message => "My message", :sending_at => Time.now + 1.hour
      Delayed::Worker.new.work_off
      
      tweet.delivered.should be_false
      
      # I should not see the tweet in the stack
      visit "/tweet-engine"
      page.should_not have_content "My message - Sent"
    end
  
    it "a canceled tweet should not be sent out" do
      tweet = TweetEngine::Stack.create! :message => "My message", :sending_at => Time.now + 1.hour
      Delayed::Worker.new.work_off
      
      tweet.delivered.should be_false
      
      # I should not see the tweet in the stack
      visit "/tweet-engine"
      page.should_not have_content "My message - Sent"
      
      # we cancel the tweet
      click_link "Delete"
      
      Delayed::Worker.new.work_off
      
      tweet.delivered.should be_false
      
      # I should not see the tweet in the stack
      visit "/tweet-engine"
      page.should_not have_content "My message - Sent"
    end
    
    it "allows us to send a tweet out repeatedly" do
      visit "/tweet-engine"
      
      fill_in "Enter Tweet", :with => "This is my new tweet"
      check 'Repeat'
      fill_in "Every", :with => "2 hours"
      click_button "Stack Tweet"
      
      page.should have_content "Added new tweet to the stack"
      Delayed::Worker.new.work_off
      
      time = Time.now.utc
      
      # times goes on
      time += 2.hours
      Timecop.travel(time)
      
      # message is sent
      visit "/tweet-engine"

      page.should have_content "This is my new tweet"
      page.should have_content "this was sent"
      
      # a new message is created with the same contents
      page.should have_content "This is my new tweet"
      # we can see the rescheduled tweet in the stack
      page.should have_content "Sending in less than a minute this will be repeated every 2 hours"
    end
  end
  
  context "unfollowing a user" do
    it "allows me to unfollow people I am following" do
      stub_request(:get, "https://api.twitter.com/1/statuses/friends.json?cursor=-1").
        to_return(:status => 200, :body => fixture('friends.json'), :headers => {})
      stub_request(:delete, "https://api.twitter.com/1/friendships/destroy.json?screen_name=timoreilly").
        to_return(:status => 200, :body => "", :headers => {})
      # visit the stack
      visit "/tweet-engine"
    
      click_link "following"
      
      # follow the unfollow link
      check 'unfollow_0'
      
      click_button "Unfollow tweeple"
      
      # I should see a list of people I am following
      page.should have_content "Unfollowed 1 tweeple"
    end
    
    it "allows me to unfollow people that follow me" do
      stub_request(:get, "https://api.twitter.com/1/statuses/followers.json?cursor=-1").
        to_return(:status => 200, :body => fixture('followers.json'), :headers => {})
      stub_request(:get, "https://api.twitter.com/1/statuses/followers.json?cursor=1344637399602463196").
        to_return(:status => 200, :body => fixture('followers2.json'), :headers => {})
      stub_request(:delete, "https://api.twitter.com/1/friendships/destroy.json?screen_name=chachasikes").
        to_return(:status => 200, :body => "", :headers => {})
      
      # visit the stack
      visit "/tweet-engine"
    
      click_link "followers"
      
      # follow the unfollow link
      check 'unfollow_1'
      
      click_button "Unfollow tweeple"
      
      # I should see a list of people I am following
      page.should have_content "Unfollowed 1 tweeple"
    end
  end
  
  context "following potentials followers" do
    it "should be able to follower tweeple I have found" do
      stub_request(:post, "https://api.twitter.com/1/friendships/create.json").
        to_return(:status => 200, :body => "", :headers => {})
      3.times do |amount|
        search_result = fixture('search.json')
        TweetEngine::SearchResult.create! :screen_name => "Some name #{amount}", :tweet => {:text => "Something about nothing #{amount}"}
      end
      
      # pending 'Defining steps'
      # we visit the dashboard
      visit 'tweet-engine'
      # we follow potential followers
      click_link 'potential followers'
      
      page.should have_content "Potential Followers"
      
      # Make sure we can see each potential followers information
      3.times do |number|
        page.should have_content "Some name #{number}"
        page.should have_content "Something about nothing #{number}"
      end
      
      # we click on 3 followers
      3.times do |number|
        check "followers_#{number}"
      end
      click_button 'Follow tweeple'
      
      # we are redirected back to the dashboard
      
      # we are following 3 more people
      page.should have_content "You are now following 3 more people"
    end
    
    it "automatically followers potential followers" do
      pending 'Not implemented yet'
      # There are some people to follow
      # Some times goes by
      # we should now be following those people
    end
    
    it "displays a list of recent followers that I am following"
  end
  
  context "intelligent tweeting" do
    context "auto-response" do
      
      it "allow us to add auto responses to the system" do
        # we are on the new auto-response page
        visit 'tweet-engine'
        
        click_link 'New auto-response'
        
        # we fill in the key phrase
        fill_in 'Key Phrases', :with => "Cut my hair, need a trim"
        
        # we fill in the response
        fill_in "Response", :with => "We cut hair like Sweeney Todd"
        
        # we submit the new response
        click_button "Add auto-response"
        
        page.should have_content "Added new auto-response"
      end
      
      it "auto responds to people who mention one of our key phrases" do
        # A key-phrase and response has been added
        auto_response = TweetEngine::Responder.create!(:key_phrases => "Twitter", :response => "Twitter is cool")
        auto_response.sent_to.should be_empty
        
        # Someone sends out a tweet with the key-phrase
        stub_request(:get, "https://search.twitter.com/search.json?q=Twitter").
          to_return(:status => 200, :body => fixture('search.json'), :headers => {})
        
        # Tweets are stacked
        found = TweetEngine::Responder.respond
        
        # All users should be stored as sent
        auto_response.reload
        auto_response.sent_to.should_not be_empty
        
        # Send out messages
        Delayed::Worker.new.work_off
        
        TweetEngine::Stack.all.count.should == 11
      end
      
      it "should not send out response one after the other" do
        pending 'Not implemented yet'
        # A key-phrase and response has been added
        # Someone sends out a tweet with the key-phrase
        # All users found using the key-phrase are stored
        # The first user is sent a response
        # The second user does not get sent a response for at least another minute
      end
    end
    
    it "allows us to send out a tweet depending on peoples comments"
    it "tracks conversations based on keywords"
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