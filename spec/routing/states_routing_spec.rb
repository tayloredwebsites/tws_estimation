require "spec_helper"

describe StatesController do
  describe "routing" do

    it "routes to #index" do
      get("/states").should route_to("states#index")
    end

    it "routes to #new" do
      get("/states/new").should route_to("states#new")
    end

    it "routes to #show" do
      get("/states/1").should route_to("states#show", :id => "1")
    end

    it "routes to #edit" do
      get("/states/1/edit").should route_to("states#edit", :id => "1")
    end

    it "routes to #create" do
      post("/states").should route_to("states#create")
    end

    it "routes to #update" do
      put("/states/1").should route_to("states#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/states/1").should route_to("states#destroy", :id => "1")
    end

  end
end
