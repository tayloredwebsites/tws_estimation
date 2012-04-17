require "spec_helper"

describe ComponentsController do
  describe "routing" do

    it "routes to #index" do
      get("/component_types").should route_to("component_types#index")
    end

    it "routes to #new" do
      get("/component_types/new").should route_to("component_types#new")
    end

    it "routes to #show" do
      get("/component_types/1").should route_to("component_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/component_types/1/edit").should route_to("component_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/component_types").should route_to("component_types#create")
    end

    it "routes to #update" do
      put("/component_types/1").should route_to("component_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/component_types/1").should route_to("component_types#destroy", :id => "1")
    end
    
    it "routes to #deactivate" do
      put("/component_types/1/deactivate").should route_to("component_types#deactivate", :id => "1")
    end
    
    it "routes to #reactivate" do
      put("/component_types/1/reactivate").should route_to("component_types#reactivate", :id => "1")
    end
    
    it "routes to #deactivate" do
      get("/component_types/1/deactivate").should route_to('home#errors', :status => 405, :id => "1")
    end
    
    it "routes to #reactivate" do
      get("/component_types/1/reactivate").should route_to('home#errors', :status => 405, :id => "1")
    end

  end
end
