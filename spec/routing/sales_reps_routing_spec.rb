require "spec_helper"

describe SalesRepsController do
  describe "routing" do

    it "routes to #index" do
      get("/sales_reps").should route_to("sales_reps#index")
    end

    it "routes to #new" do
      get("/sales_reps/new").should route_to("sales_reps#new")
    end

    it "routes to #show" do
      get("/sales_reps/1").should route_to("sales_reps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sales_reps/1/edit").should route_to("sales_reps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sales_reps").should route_to("sales_reps#create")
    end

    it "routes to #update" do
      put("/sales_reps/1").should route_to("sales_reps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sales_reps/1").should route_to("sales_reps#destroy", :id => "1")
    end

  end
end
