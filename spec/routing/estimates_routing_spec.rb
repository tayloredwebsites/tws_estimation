require "spec_helper"

describe EstimatesController do
  describe "routing" do

    it "routes to #index" do
      get("/estimates").should route_to("estimates#index")
    end

    it "routes to #new" do
      get("/estimates/new").should route_to("estimates#new")
    end

    it "routes to #show" do
      get("/estimates/1").should route_to("estimates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/estimates/1/edit").should route_to("estimates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/estimates").should route_to("estimates#create")
    end

    it "routes to #update" do
      put("/estimates/1").should route_to("estimates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/estimates/1").should route_to("estimates#destroy", :id => "1")
    end

  end
end
