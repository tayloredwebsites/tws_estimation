require 'spec_helper'

describe EstimateAssembly do
  context 'it should have crud actions available and working' do
    it "should raise an error create user with no attributes" do
      num_items = EstimateAssembly.count
      lambda {EstimateAssembly.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      EstimateAssembly.count.should == num_items
    end    
    it "should not create user when created with no attributes" do
      num_items = EstimateAssembly.count
      item = EstimateAssembly.create()
      EstimateAssembly.count.should == num_items
    end
    it 'should have accessible attributes match the accessible attributes for the model' do
      attribs = FactoryGirl.build(:estimate_assembly)._accessible_attributes
      # Rails.logger.debug("T estimate_create.attributes: #{attribs.inspect.to_s}")
      # Rails.logger.debug("T attribs[:default]: #{ attribs[:default].inspect.to_s}")
      attribs_whitelist = attribs[:default]
      Rails.logger.debug("T attribs_whitelist: #{attribs_whitelist.inspect.to_s}")
      acc_attribs = generate_estimate_assembly_accessible_attributes()
      Rails.logger.debug("T generate_estimate_assembly_accessible_attributes: #{acc_attribs.inspect.to_s}")
      attribs_whitelist.size.should >= acc_attribs.size # accounting for blank entry in whitelist
      attribs_whitelist.each do |key|
        Rails.logger.debug ("T Accessible attribute #{key.to_s} = #{acc_attribs[key.to_sym].inspect.to_s}")
        acc_attribs[key.to_sym].should_not be_nil if !key.blank?
      end
    end
    it 'should create EstimateAssembly when created with the minimum_attributes' do
      num_items = EstimateAssembly.count
      attribs = generate_estimate_assembly_accessible_attributes()
      Rails.logger.debug("T generate_estimate_accessible_attributes: #{attribs.inspect.to_s}")
      item1 = EstimateAssembly.create(attribs)
      item1.should be_instance_of(EstimateAssembly)
      # loop through all of the attributes used to create this item to see if in created item
      attribs.each do | key, val |
        Rails.logger.debug("T estimate_type_spec estimate_types_min item1.send(#{key}):#{item1.send(key)}")
        item1.send(key).should == val
      end
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      EstimateAssembly.count.should == num_items + 1
    end   
    it 'should not create estimate_types when created missing one of the minimum_attributes' do
      num_items = EstimateAssembly.count
      attribs = generate_estimate_assembly_min_attributes()
      attribs.each do | atrkey, atrval |
        Rails.logger.debug("T estimate_type_spec estimate_types_min - try to create item without key:#{atrkey}")
        attribs_missing = attribs.reject{|itekey, iteval| itekey == atrkey}
        item1 = EstimateAssembly.create(attribs_missing)  # remove attrib key from this item create
        item1.should be_instance_of(EstimateAssembly)
        # if we care what values are placed in an error object --
        # loop through all of the attributes used to create this item to see if in created item
        attribs_missing.each do | key, val |
          Rails.logger.debug("T estimate_type_spec estimate_types_min item1.send(#{key}):#{item1.send(key)}")
          item1.send(key).should == val
        end
        # item1.send(atrkey).should == nil
        item1.id.should be_nil
        item1.errors.count.should > 0
        EstimateAssembly.count.should == num_items
      end
    end   
  end
  context 'it should be associated with estimates and assemblies' do
    before (:each) do
      @parent = Estimate.create!(generate_estimate_accessible_attributes)
      @assembly1 = FactoryGirl.create(:assembly_create) #Assembly.create!(generate_estimate_accessible_attributes)
      @assembly2 = FactoryGirl.create(:assembly_create) #Assembly.create!(generate_estimate_accessible_attributes)
    end
    it 'should not allow destroy of Estimate if there are estimate_assemblies' do
      estimate_assembly_1 = FactoryGirl.create(:estimate_assembly, estimate: @parent, assembly: @assembly1)
      Rails.logger.debug("TTTTEstimateAssembly estimate_assembly_1 = #{estimate_assembly_1.inspect.to_s}")
      estimate_assembly_2 = FactoryGirl.create(:estimate_assembly, estimate: @parent, assembly: @assembly2)
      Rails.logger.debug("TTTTEstimateAssembly estimate_assembly_2 = #{estimate_assembly_2.inspect.to_s}")
      Rails.logger.debug("TTTTEstimateAssembly @parent = #{@parent.inspect.to_s}")
      @parent.estimate_assemblies.length.should == 2
      num_parent = Estimate.count
      @parent.deactivate()
      @parent.destroy()
      @parent.errors.count.should > 0
      Estimate.count.should == num_parent
    end
    it 'should not allow destroy of Assembly if there are estimate_assemblies' do
      # FactoryGirl.create(:estimate_assembly, estimate: @parent, assembly: @assembly1)
      FactoryGirl.create(:estimate_assembly, estimate: @parent, assembly: @assembly2)
      @parent.estimate_assemblies.length.should == 1
      num_parent = Estimate.count
      @assembly1.deactivate()
      @assembly1.destroy()
      @assembly1.errors.count.should == 0
      @assembly2.deactivate()
      @assembly2.destroy()
      @assembly2.errors.count.should > 0
      Estimate.count.should == num_parent
    end
    it 'should allow destroy of estimate if there are no estimate_assemblies' do
      num_parent = Estimate.count
      @parent.deactivate()
      @parent.destroy()
      @parent.errors.count.should == 0
      Estimate.count.should == num_parent - 1
    end
  end
  
  context "Estimate update attributes passed to EstimateAssembly - " do
    before (:each) do
      # @estimate = Estimate.create!(generate_estimate_accessible_attributes)
      @assembly1 = FactoryGirl.create(:assembly_create) #Assembly.create!(generate_estimate_accessible_attributes)
      @assembly2 = FactoryGirl.create(:assembly_create) #Assembly.create!(generate_estimate_accessible_attributes)
    end
    it "Estimate.create should create Estimate and estimate assemblies" do
      attribs = generate_estimate_accessible_attributes
      # attribs[:estimate_assembly_attributes]= {"#{@assembly1.id.to_s}"=>"#{@assembly1.id.to_s}", "#{@assembly2.id.to_s}"=>"#{@assembly2.id.to_s}"}
      # attribs[:estimate_assemblies_was] = {"#{@assembly1.id.to_s}"=>"false", "#{@assembly2.id.to_s}"=>"false"}
      Rails.logger.debug("T attribs = #{attribs.inspect.to_s}")
      estimate = Estimate.new(attribs)
      c_attribs1 = {:estimate_id=>"0", :assembly_id=>"#{@assembly1.id.to_s}", :selected => true}
      Rails.logger.debug("T c_attribs1 = #{c_attribs1.inspect.to_s}")
      estimate.estimate_assemblies.build(c_attribs1)
      # c_attribs2 = {:estimate_id=>"0", :assembly_id=>"#{@assembly2.id.to_s}", :selected => true}
      # Rails.logger.debug("T c_attribs2 = #{c_attribs2.inspect.to_s}")
      # estimate.estimate_assemblies.build(c_attribs2)
      Rails.logger.debug("T estimate.estimate_assemblies = #{estimate.estimate_assemblies.inspect.to_s}")
      estimate.save!
      item1_updated = Estimate.find(estimate.id)
      Rails.logger.debug("T item1_updated = #{item1_updated.inspect.to_s}")
      Rails.logger.debug("T item1_updated.estimate_assemblies = #{item1_updated.estimate_assemblies.inspect.to_s}")
      item1_updated.estimate_assemblies.first.assembly_id.should == @assembly1.id
      # item1_updated.estimate_components.first.component_id.should == @component1.id
    end
    it "Estimate.update_attributes should call the update_estimate_assemblies_attributes of Estimate" do
      attribs = generate_estimate_accessible_attributes
      Rails.logger.debug("T attribs = #{attribs.inspect.to_s}")
      estimate = Estimate.create!(attribs)
      c_attribs1 = {:estimate_id=>"0", :assembly_id=>"#{@assembly1.id.to_s}", :selected => true}
      Rails.logger.debug("T c_attribs1 = #{c_attribs1.inspect.to_s}")
      estimate.estimate_assemblies.build(c_attribs1)
      # c_attribs2 = {:estimate_id=>"0", :assembly_id=>"#{@assembly2.id.to_s}", :selected => true}
      # Rails.logger.debug("T c_attribs2 = #{c_attribs2.inspect.to_s}")
      # estimate.estimate_assemblies.build(c_attribs2)
      estimate.save
      item1_updated = Estimate.find(estimate.id)
      Rails.logger.debug("T item1_updated = #{item1_updated.inspect.to_s}")
      Rails.logger.debug("T item1_updated.estimate_assemblies = #{item1_updated.estimate_assemblies.inspect.to_s}")
      item1_updated.estimate_assemblies.first.assembly_id.should == @assembly1.id
    end
  end
end
