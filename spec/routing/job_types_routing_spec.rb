require "spec_helper"

describe JobTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/job_types").should route_to("job_types#index")
    end

    it "routes to #new" do
      get("/job_types/new").should route_to("job_types#new")
    end

    it "routes to #show" do
      get("/job_types/1").should route_to("job_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/job_types/1/edit").should route_to("job_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/job_types").should route_to("job_types#create")
    end

    it "routes to #update" do
      put("/job_types/1").should route_to("job_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/job_types/1").should route_to("job_types#destroy", :id => "1")
    end

    it "routes to #deactivate" do
      put("/job_types/1/deactivate").should route_to("job_types#deactivate", :id => "1")
    end
    
    it "routes to #reactivate" do
      put("/job_types/1/reactivate").should route_to("job_types#reactivate", :id => "1")
    end
    
    it "routes to #deactivate" do
      get("/job_types/1/deactivate").should route_to('home#errors', :status => 405, :id => "1")
    end
    
    it "routes to #reactivate" do
      get("/job_types/1/reactivate").should route_to('home#errors', :status => 405, :id => "1")
    end

  end
end
