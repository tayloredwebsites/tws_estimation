require "spec_helper"

describe ComponentsController do
  describe "routing" do

    it "routes to #index" do
      get("/components").should route_to("components#index")
    end

    it "routes to #menu" do
      get("/components/menu").should route_to("components#menu")
    end

    it "routes to #list" do
      get("/components/list").should route_to("components#list")
    end

    it "routes to #new" do
      get("/components/new").should route_to("components#new")
    end

    it "routes to #show" do
      get("/components/1").should route_to("components#show", :id => "1")
    end

    it "routes to #edit" do
      get("/components/1/edit").should route_to("components#edit", :id => "1")
    end

    it "routes to #create" do
      post("/components").should route_to("components#create")
    end

    it "routes to #update" do
      put("/components/1").should route_to("components#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/components/1").should route_to("components#destroy", :id => "1")
    end
    
    it "routes to #deactivate" do
      put("/components/1/deactivate").should route_to("components#deactivate", :id => "1")
    end
    
    it "routes to #reactivate" do
      put("/components/1/reactivate").should route_to("components#reactivate", :id => "1")
    end
    
    it "routes to #deactivate" do
      get("/components/1/deactivate").should route_to('home#errors', :status => 405, :id => "1")
    end
    
    it "routes to #reactivate" do
      get("/components/1/reactivate").should route_to('home#errors', :status => 405, :id => "1")
    end

  end
end
