require "spec_helper"

describe AssemblyComponentsController do
  describe "routing" do

    it "routes to #index" do
      get("/assembly_components").should route_to("assembly_components#index")
    end

    it "routes to #new" do
      get("/assembly_components/new").should route_to("assembly_components#new")
    end

    it "routes to #show" do
      get("/assembly_components/1").should route_to("assembly_components#show", :id => "1")
    end

    it "routes to #edit" do
      get("/assembly_components/1/edit").should route_to("assembly_components#edit", :id => "1")
    end

    it "routes to #create" do
      post("/assembly_components").should route_to("assembly_components#create")
    end

    it "routes to #update" do
      put("/assembly_components/1").should route_to("assembly_components#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/assembly_components/1").should route_to("assembly_components#destroy", :id => "1")
    end

  end
end
