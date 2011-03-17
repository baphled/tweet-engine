require 'spec_helper'

describe "Navigation" do
  include Capybara
  
  it "should be a valid app" do
    ::Rails.application.should be_a(Dummy::Application)
  end
  
  it "should let me view tweet stack" do
    visit "/tweet-stack"
    page.should have_content "Tweet stack"
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
    visit "/tweet-stack"
    fill_in "Search for:", :with => "lemons"
    click_button "Search"
    
    #select all tweeple found
    check "tweet_stack[1]"
    # press follow
    click_button "Follow"
    
    # should see a list of users that I am now following
    page.should have_content "You are now following killermelons"
  end
  
  it "should be able to store a the found tweeple for later"
  it "tweeple I am following should be removed from the to add list"
  it "it alls me to stack up tweets"
  it "allows me to schedule my tweets"
  it "allows me to reschedule tweets"
  it "displays a list of recent followers that I am following"
  it "allows me to unfollow people I am following"
  
  context "settings" do
    it "allows me to manage the amount of tweeple I can follow a day"
    it "allows me to manage the amount of tweets I send out a day"
  end
end
