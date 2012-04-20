require "spec_helper"

describe AssemblyComponentsController do
  describe "routing" do

    it "routes to #index" do
      get("/assembly_components").should route_to("assembly_components#index")
    end

    it "routes to #menu" do
      get("/assembly_components/menu").should route_to("assembly_components#menu")
    end

    it "routes to #list" do
      get("/assembly_components/list").should route_to("assembly_components#list")
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

    it "routes to #deactivate" do
      put("/assembly_components/1/deactivate").should route_to("assembly_components#deactivate", :id => "1")
    end
    
    it "routes to #reactivate" do
      put("/assembly_components/1/reactivate").should route_to("assembly_components#reactivate", :id => "1")
    end
    
    it "routes to #deactivate" do
      get("/assembly_components/1/deactivate").should route_to('home#errors', :status => 405, :id => "1")
    end
    
    it "routes to #reactivate" do
      get("/assembly_components/1/reactivate").should route_to('home#errors', :status => 405, :id => "1")
    end

  end
end
