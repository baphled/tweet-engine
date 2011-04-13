require "spec_helper"

describe TweetEngine::AutoResponseController do
  before(:each) do
    stub_request(:get, "https://api.twitter.com/1/account/verify_credentials.json").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
    stub_request(:get, "https://api.twitter.com/1/users/show.json?screen_name=pengwynn").
      to_return(:status => 200, :body => fixture('pengwynn.json'), :headers => {})
  end
  
  describe "GET, new" do
    it "instantiates a new response" do
      TweetEngine::Responder.should_receive :new
      get :new
    end
  end
  
  describe "POST, create" do
    before(:each) do
      @auto_response = TweetEngine::Responder.new(:key_phrases => "Rails, Ruby", :response => 'Rails 3 is very cool')
      TweetEngine::Responder.stub!(:new).and_return @auto_response
    end
    
    it "instantiates a new response" do
      TweetEngine::Responder.should_receive :new
      post :create, { :tweet_engine_responder => { :key_phrases => "Rails, Ruby", :response => "Rails 3 is very cool"} }
    end
    
    it "saves the response" do
      @auto_response.should_receive(:save).and_return true
      post :create, { :tweet_engine_responder => { :key_phrases => "Rails, Ruby", :response => "Rails 3 is very cool"} }
    end
    
    context "successful" do
      before(:each) do
        @auto_response.stub!(:save).and_return true
        TweetEngine::Responder.stub!(:new).and_return @auto_response
      end
      
      it "saves the response" do
        @auto_response.should_receive(:save).and_return true
        post :create, { :tweet_engine_responder => { :key_phrases => "Rails, Ruby", :response => "Rails 3 is very cool"} }
      end
      
      it "redirects to the tweet-engine" do
        post :create, { :tweet_engine_responder => { :key_phrases => "Rails, Ruby", :response => "Rails 3 is very cool"} }
        response.should redirect_to tweet_engine_path
      end
    end
  end
end
