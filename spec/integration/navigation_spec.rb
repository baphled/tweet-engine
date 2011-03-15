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
  
  it "should let me do a search based on a phrase"
end
