require "spec_helper"

describe AssembliesController do
  describe "routing" do

    it "routes to #index" do
      get("/assemblies").should route_to("assemblies#index")
    end

    it "routes to #menu" do
      get("/assemblies/menu").should route_to("assemblies#menu")
    end

    it "routes to #list" do
      get("/components/list").should route_to("components#list")
    end

    it "routes to #new" do
      get("/assemblies/new").should route_to("assemblies#new")
    end

    it "routes to #show" do
      get("/assemblies/1").should route_to("assemblies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/assemblies/1/edit").should route_to("assemblies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/assemblies").should route_to("assemblies#create")
    end

    it "routes to #update" do
      put("/assemblies/1").should route_to("assemblies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/assemblies/1").should route_to("assemblies#destroy", :id => "1")
    end

    it "routes to #deactivate" do
      put("/assemblies/1/deactivate").should route_to("assemblies#deactivate", :id => "1")
    end
    
    it "routes to #reactivate" do
      put("/assemblies/1/reactivate").should route_to("assemblies#reactivate", :id => "1")
    end
    
    it "routes to #deactivate" do
      get("/assemblies/1/deactivate").should route_to('home#errors', :status => 405, :id => "1")
    end
    
    it "routes to #reactivate" do
      get("/assemblies/1/reactivate").should route_to('home#errors', :status => 405, :id => "1")
    end

  end
end
