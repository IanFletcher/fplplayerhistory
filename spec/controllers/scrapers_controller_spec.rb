require 'spec_helper'

describe ScrapersController do

  describe "GET 'launch'" do
    it "returns http success" do
      get 'launch'
      response.should be_success
    end
  end

end
