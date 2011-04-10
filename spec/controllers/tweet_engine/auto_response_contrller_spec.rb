require "spec_helper"

describe TweetEngine::AutoResponseController do

  describe "GET, new" do
    it "instantiates a new response" do
      TweetEngine::AutoResponse.should_receive :new
      get :new
    end
  end
  
  describe "POST, create" do
    before(:each) do
      @auto_response = TweetEngine::AutoResponse.new(:key_phrases => "Rails, Ruby", :response => 'Rails 3 is very cool')
      TweetEngine::AutoResponse.stub!(:new).and_return @auto_response
    end
    
    it "instantiates a new response" do
      TweetEngine::AutoResponse.should_receive :new
      post :create, { :tweet_engine_auto_response => { :key_phrases => "Rails, Ruby", :response => "Rails 3 is very cool"} }
    end
    
    context "successful" do
      before(:each) do
        @auto_response.stub!(:save).and_return true
        TweetEngine::AutoResponse.stub!(:new).and_return @auto_response
      end
      
      it "saves the response" do
        @auto_response.should_receive(:save).and_return true
        post :create, { :tweet_engine_auto_response => { :key_phrases => "Rails, Ruby", :response => "Rails 3 is very cool"} }
      end
      
      it "redirects to the tweet-engine" do
        post :create, { :tweet_engine_auto_response => { :key_phrases => "Rails, Ruby", :response => "Rails 3 is very cool"} }
        response.should redirect_to tweet_engine_path
      end
    end
  end
end
