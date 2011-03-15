require "spec_helper"

describe TweetStackController do
  describe "GET, index" do
    it "displays the index page" do
      get :index
      response.status.should == 200
    end
  end
end