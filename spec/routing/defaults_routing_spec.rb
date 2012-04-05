require "spec_helper"

describe ComponentsController do
  describe "routing" do

    it "routes to #index" do
      get("/defaults").should route_to("defaults#index")
    end

    it "routes to #new" do
      get("/defaults/new").should route_to("defaults#new")
    end

    it "routes to #show" do
      get("/defaults/1").should route_to("defaults#show", :id => "1")
    end

    it "routes to #edit" do
      get("/defaults/1/edit").should route_to("defaults#edit", :id => "1")
    end

    it "routes to #create" do
      post("/defaults").should route_to("defaults#create")
    end

    it "routes to #update" do
      put("/defaults/1").should route_to("defaults#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/defaults/1").should route_to("defaults#destroy", :id => "1")
    end
    
    it "routes to #deactivate" do
      put("/defaults/1/deactivate").should route_to("defaults#deactivate", :id => "1")
    end
    
    it "routes to #reactivate" do
      put("/defaults/1/reactivate").should route_to("defaults#reactivate", :id => "1")
    end
    
    it "routes to #deactivate" do
      get("/defaults/1/deactivate").should route_to('home#errors', :status => 405, :id => "1")
    end
    
    it "routes to #reactivate" do
      get("/defaults/1/reactivate").should route_to('home#errors', :status => 405, :id => "1")
    end

  end
end
