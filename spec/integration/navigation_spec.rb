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
  
  
  it "it alls me to stack up tweets" do
    visit "/tweet-stack"
    
    fill_in "Enter Tweet", :with => "This is my new tweet"
    click_button "Stack Tweet"
    
    page.should have_content "Added new tweet to the stack"
    page.should have_content "Stacked tweets"
    page.should have_content "This is my new tweet"
    
  end
  
  it "allows me to schedule my tweets"
  it "allows me to reschedule tweets"
  it "displays a list of recent followers that I am following"
  it "allows me to unfollow people I am following"
  it "should be able to store a the found tweeple for later"
  
  context "settings" do
    it "allows me to manage the amount of tweeple I can follow a day"
    it "allows me to manage the amount of tweets I send out a day"
  end
end
